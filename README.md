# spotify-cli-macos
A command line interface to Spotify on macOS

Please note: you need to have Spotify desktop app installed on your computer in order to use this script

If you're using Linux, see: [spotify-cli-linux](https://github.com/pwittchen/spotify-cli-linux)

## installation

```
git clone https://github.com/pwittchen/spotify-cli-macos.git
cd spotify-cli-macos
make install
```

## uninstallation

```
make uninstall
```

## update

```
cd spotify-cli-macos
git pull
make install
```

## usage

```
spotifycli <command>
```

e.g.

```
spotifycli help
```

all available commands:

```
activate    activate spotify
status      check if spotify app is running
play        play the song
pause       pause the song
playpause   play or pause the song
next        play next track
prev        play previous track
restart     restart current track
track       show artist and song title
quit        quit spotify
help        show help
```

## MCP server

This repo also ships an MCP (Model Context Protocol) server at `mcp/spotifycli-mcp.sh` that exposes every `spotifycli` command as an MCP tool, so any MCP client (Claude Desktop, Claude Code, etc.) can drive Spotify.

Install both the CLI and the MCP server:

```
make install
make install-mcp
```

Then register it with your MCP client. Example for Claude Desktop (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "spotify": {
      "command": "/usr/local/bin/spotifycli-mcp"
    }
  }
}
```

Or with Claude Code:

```
claude mcp add spotify /usr/local/bin/spotifycli-mcp
```

The server is a Bash script that shells out to `spotifycli`; it requires `jq` (preinstalled on macOS 15+) and `spotifycli` on `PATH`.

To uninstall: `make uninstall-mcp`.

## Claude Code skill

This repo ships a [Claude Code](https://claude.com/claude-code) skill at `.claude/skills/spotify/SKILL.md`. When Claude Code is run from this directory, you can drive Spotify in natural language:

```
/spotify what's playing
/spotify pause
/spotify next track
```

The skill assumes `spotifycli` is on `PATH`, so run `make install` first.
