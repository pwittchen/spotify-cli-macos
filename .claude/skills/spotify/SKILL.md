---
name: spotify
description: Control the Spotify desktop app on macOS via the `spotifycli` command. Use when the user wants to play, pause, skip, restart, or query the currently playing track on Spotify; activate or quit the Spotify app; or check whether Spotify is running. macOS only — requires the Spotify desktop app and `spotifycli` installed in PATH (`make install` from the spotify-cli-macos repo).
---

# spotify

Wrapper skill for the `spotifycli` shell tool, which drives Spotify on macOS through AppleScript (`osascript`).

## Prerequisites

- macOS with the Spotify desktop app installed.
- `spotifycli` available on PATH. If `command -v spotifycli` returns nothing, tell the user to run `make install` in the spotify-cli-macos repo and stop — do not fall back to invoking AppleScript directly.

## Commands

Invoke via Bash as `spotifycli <command>`:

| Command | Effect |
|---|---|
| `activate` | Bring Spotify to the foreground (launches it if not running). |
| `status` | Prints `running` or `off`. |
| `play` | Start playback. |
| `pause` | Pause playback. |
| `playpause` | Toggle play/pause. |
| `next` | Skip to next track. |
| `prev` | Go to previous track (the underlying script calls it twice so it actually moves back instead of restarting the current track). |
| `restart` | Seek current track to position 0. |
| `track` | Print `<song> - <artist>` for the current track. |
| `quit` | Quit the Spotify app. |
| `help` | Print usage. |

## How to use

- Map natural-language requests to the matching command. Examples:
  - "what's playing" / "what song is this" → `spotifycli track`
  - "pause" / "stop the music" → `spotifycli pause`
  - "skip" / "next song" → `spotifycli next`
  - "go back" / "previous track" → `spotifycli prev`
  - "restart this song" → `spotifycli restart`
  - "is Spotify running" → `spotifycli status`
  - "open Spotify" → `spotifycli activate`
  - "close Spotify" → `spotifycli quit`
- For ambiguous requests like "play X" where X is a song/artist/playlist name, this tool cannot search or queue — explain the limitation. It only controls the currently loaded track.
- Before `play`, `pause`, `next`, `prev`, `track`, or `restart`, run `spotifycli status` if there's any chance Spotify isn't running; the AppleScript commands will launch Spotify implicitly but `track` against a stopped app returns nothing useful.
- `quit` closes the user's music app — confirm with the user before running it unless they asked explicitly.

## Output handling

- `status` and `track` print to stdout — relay the result verbatim to the user.
- The action commands (`play`, `pause`, etc.) produce no output on success. Don't fabricate confirmation; a successful exit code is the signal.
