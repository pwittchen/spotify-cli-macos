#!/usr/bin/env bash

if [[ $1 == "activate" ]]; then
    osascript -e 'tell application "Spotify" to activate'
    exit
elif [[ $1 == "status" ]]; then
    status_value=$(osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"')
    [[ $status_value == "true" ]] && echo "running" || echo "off"
    exit
elif [[ $1 == "play" ]]; then
    osascript -e 'tell application "Spotify" to play'
    exit
elif [[ $1 == "pause" ]]; then
    osascript -e 'tell application "Spotify" to pause'
    exit
elif [[ $1 == "playpause" ]]; then
    osascript -e 'tell application "Spotify" to playpause'
    exit
elif [[ $1 == "restart" ]]; then
    osascript -e 'tell application "Spotify" to set player position to 0'
    exit
elif [[ $1 == "next" ]]; then
    osascript -e 'tell application "Spotify" to next track'
    exit
elif [[ $1 == "prev" ]]; then
    # it has to be invoked twice, otherwise it goes to the beginning of the current track
    osascript -e 'tell application "Spotify" to previous track'
    osascript -e 'tell application "Spotify" to previous track'
    exit
elif [[ $1 == "track" ]]; then
    osascript -e 'tell application "Spotify" to name of current track & " - " & artist of current track'
    exit
else
    echo "usage: spotifycli <command>"
    echo ""
    echo "available commands:"
    echo ""
    echo "  activate    activate spotify"
    echo "  status      check if spotify app is running"
    echo "  play        play the song"
    echo "  pause       pause the song"
    echo "  playpause   play or pause the song"
    echo "  next        play next track"
    echo "  prev        play previous track"
    echo "  restart     restart current track"
    echo "  track       show artist and song title"
    echo "  help        show help"
    exit 0
fi

