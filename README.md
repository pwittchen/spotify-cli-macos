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
