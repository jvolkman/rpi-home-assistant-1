[![blakeblackshear/rpi-home-assistant](https://img.shields.io/docker/stars/blakeblackshear/rpi-home-assistant.svg)](https://hub.docker.com/r/blakeblackshear/rpi-home-assistant/)
[![blakeblackshear/rpi-home-assistant](https://img.shields.io/docker/pulls/blakeblackshear/rpi-home-assistant.svg)](https://hub.docker.com/r/blakeblackshear/rpi-home-assistant/)

# Docker image for Home Assistant on the Raspberry Pi
This build is designed to follow the official docker container as closely as
possible. It includes Z-Wave support.

These builds are not automated. I will update the version of Home Assistant
when I can.

## Running
You will need to share your zwave device with the container with `--device`:
```
docker run -d --name="home-assistant" -v /path/to/your/config:/config -v /etc/localtime:/etc/localtime:ro --net=host --device=/dev/zwave blakeblackshear/rpi-home-assistant:0.35.3
```

I recommend setting up an alias for your zwave device as documented [here](http://hintshop.ludvig.co.nz/show/persistent-names-usb-serial-devices/).

## Building
Replace the name/tag below for your needs:
```
docker build -t blakeblackshear/rpi-home-assistant:0.35.3 .
```
