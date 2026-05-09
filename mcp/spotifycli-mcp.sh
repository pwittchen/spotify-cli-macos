#!/usr/bin/env bash
# MCP server for spotify-cli-macos.
# Speaks JSON-RPC 2.0 over stdio (Model Context Protocol).
# Requires `jq` and `spotifycli` on PATH.

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
    echo "spotifycli-mcp: jq is required but not found on PATH" >&2
    exit 1
fi

if ! command -v spotifycli >/dev/null 2>&1; then
    echo "spotifycli-mcp: spotifycli is required but not found on PATH (run 'make install')" >&2
    exit 1
fi

PROTOCOL_VERSION="2025-06-18"
SERVER_NAME="spotify-cli-macos"
SERVER_VERSION="1.0.0"

TOOLS_JSON='[
  {"name":"activate","description":"Activate (focus) the Spotify desktop app.","inputSchema":{"type":"object","properties":{}}},
  {"name":"status","description":"Check whether the Spotify app is running. Returns \"running\" or \"off\".","inputSchema":{"type":"object","properties":{}}},
  {"name":"play","description":"Start playback.","inputSchema":{"type":"object","properties":{}}},
  {"name":"pause","description":"Pause playback.","inputSchema":{"type":"object","properties":{}}},
  {"name":"playpause","description":"Toggle play/pause.","inputSchema":{"type":"object","properties":{}}},
  {"name":"next","description":"Skip to the next track.","inputSchema":{"type":"object","properties":{}}},
  {"name":"prev","description":"Go to the previous track.","inputSchema":{"type":"object","properties":{}}},
  {"name":"restart","description":"Restart the current track from position 0.","inputSchema":{"type":"object","properties":{}}},
  {"name":"track","description":"Return the current track in the form \"<title> - <artist>\".","inputSchema":{"type":"object","properties":{}}},
  {"name":"quit","description":"Quit the Spotify app.","inputSchema":{"type":"object","properties":{}}}
]'

handle_request() {
    local request="$1"
    local id method tool_name output exit_code

    id=$(jq -c '.id // empty' <<<"$request" 2>/dev/null || true)
    method=$(jq -r '.method // empty' <<<"$request" 2>/dev/null || true)

    # Notifications (no id) get no response.
    if [[ -z "$id" ]]; then
        return 0
    fi

    case "$method" in
        initialize)
            jq -nc \
                --arg pv "$PROTOCOL_VERSION" \
                --arg sn "$SERVER_NAME" \
                --arg sv "$SERVER_VERSION" \
                --argjson id "$id" \
                '{jsonrpc:"2.0", id:$id, result:{protocolVersion:$pv, capabilities:{tools:{}}, serverInfo:{name:$sn, version:$sv}}}'
            ;;
        tools/list)
            jq -nc \
                --argjson tools "$TOOLS_JSON" \
                --argjson id "$id" \
                '{jsonrpc:"2.0", id:$id, result:{tools:$tools}}'
            ;;
        tools/call)
            tool_name=$(jq -r '.params.name // empty' <<<"$request")

            if ! jq -e --arg n "$tool_name" 'any(.[]; .name == $n)' <<<"$TOOLS_JSON" >/dev/null; then
                jq -nc \
                    --argjson id "$id" \
                    --arg msg "Unknown tool: $tool_name" \
                    '{jsonrpc:"2.0", id:$id, error:{code:-32602, message:$msg}}'
                return 0
            fi

            output=$(spotifycli "$tool_name" 2>&1)
            exit_code=$?
            [[ -z "$output" ]] && output="ok"

            jq -nc \
                --argjson id "$id" \
                --arg text "$output" \
                --argjson err "$( [[ $exit_code -eq 0 ]] && echo false || echo true )" \
                '{jsonrpc:"2.0", id:$id, result:{content:[{type:"text", text:$text}], isError:$err}}'
            ;;
        ping)
            jq -nc --argjson id "$id" '{jsonrpc:"2.0", id:$id, result:{}}'
            ;;
        *)
            jq -nc \
                --argjson id "$id" \
                --arg msg "Method not found: $method" \
                '{jsonrpc:"2.0", id:$id, error:{code:-32601, message:$msg}}'
            ;;
    esac
}

while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    response=$(handle_request "$line")
    if [[ -n "$response" ]]; then
        printf '%s\n' "$response"
    fi
done
