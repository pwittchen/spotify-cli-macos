# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single-file Bash CLI (`spotifycli.sh`) that controls the Spotify desktop app on macOS by shelling out to `osascript`. There is no build system, no test suite, no linter, and no dependencies beyond a stock macOS install with the Spotify desktop app.

## Commands

- `make install` — copies `spotifycli.sh` to `/usr/local/bin/spotifycli` (uses `sudo`).
- `make uninstall` — removes `/usr/local/bin/spotifycli` (uses `sudo`; tolerant of missing file).
- `make install-mcp` / `make uninstall-mcp` — install/remove the MCP server at `/usr/local/bin/spotifycli-mcp`.
- `bash spotifycli.sh <command>` — run without installing, e.g. `bash spotifycli.sh track`.

After editing `spotifycli.sh`, re-run `make install` to deploy the new version to PATH.

## Architecture

`spotifycli.sh` is a flat `if`/`elif` chain dispatching on `$1`. Each branch issues a single `osascript -e 'tell application "Spotify" to ...'` (or `"System Events"` for `status`) and `exit 0`. The trailing `else` prints the help text.

`mcp/spotifycli-mcp.sh` is an MCP (Model Context Protocol) server written in Bash. It speaks JSON-RPC 2.0 over stdio, advertises one MCP tool per CLI subcommand, and shells out to `spotifycli` to execute them. It depends on `jq` for JSON encoding/decoding (preinstalled on macOS 15+).

When adding a new subcommand, four places must stay in sync:
1. A new `elif` branch in `spotifycli.sh`.
2. The help block in the `else` branch of `spotifycli.sh`.
3. The "all available commands" list in `README.md`.
4. The `TOOLS_JSON` array in `mcp/spotifycli-mcp.sh`.

## Non-obvious behavior

- `prev` calls `previous track` **twice** intentionally — Spotify's first `previous track` only seeks to position 0 of the current track; the second one actually moves to the previous track.
- `status` uses `tell application "System Events"` to check the process list rather than asking Spotify directly, so it works whether or not Spotify is running.
- Every branch ends with `exit 0` rather than falling through, including the help branch — `exit 0` is deliberate (commit `0ad95de` changed `exit` to `exit 0` for a conventional success code).
