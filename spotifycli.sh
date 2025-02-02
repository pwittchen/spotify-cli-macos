#!/usr/bin/env bash

show_help() {
    echo "usage: spotifycli <command>"
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
}

activate() {
    osascript -e 'tell application "Spotify" to activate'
}

status() {
    status_value=$(osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"')
    if [[ $status_value == "true" ]]; then
        echo "spotify app is running"
    else
        echo "spotify app is off"
    fi
}

play() {
    osascript -e 'tell application "Spotify" to play'
}

pause() {
    osascript -e 'tell application "Spotify" to pause'
}

playpause() {
    osascript -e 'tell application "Spotify" to playpause'
}

restart() {
    osascript -e 'tell application "Spotify" to set player position to 0'
}

next() {
    osascript -e 'tell application "Spotify" to next track'
}

prev() {
    # it has to be invoked twice, otherwise it goes to the beginning of the current track
    osascript -e 'tell application "Spotify" to previous track'
    osascript -e 'tell application "Spotify" to previous track'
}

track() {
    osascript -e 'tell application "Spotify" to name of current track & " - " & artist of current track'
}

if [[ $1 == "activate" ]]; then
    activate
    exit
elif [[ $1 == "status" ]]; then
    status
    exit
elif [[ $1 == "play" ]]; then
    play
    exit
elif [[ $1 == "pause" ]]; then
    pause
    exit
elif [[ $1 == "playpause" ]]; then
    pause
    exit
elif [[ $1 == "restart" ]]; then
    restart
    exit
elif [[ $1 == "next" ]]; then
    next
    exit
elif [[ $1 == "prev" ]]; then
    prev
    exit
elif [[ $1 == "track" ]]; then
    track
    exit
else
    show_help
fi

