# spotify-cli-macos
A command line interface to Spotify on macOS

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
spotifycli help
```

all available parameters:

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
help        show help
```
