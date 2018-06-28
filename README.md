# rpi-mongo

This repository contains Dockerfile of [MongoDB](http://www.mongodb.org/) for [Raspberry Pi](https://www.raspberrypi.org/) published to the public [Docker Hub](https://hub.docker.com/r/azcoigreach/).

This Build for Raspberry Pi 3 with ARMv8 aarch64 processor.  This is a 64bit build and must be run on a 64bit OS.  At the
time of this Git, there is no official 64bit Raspbian OS.  I am building this project with [OpenSuSe JeOS LEAP 42.3](https://en.opensuse.org/HCL:Raspberry_Pi3). This is required for Mongodb 3.0 and up.

### Base Docker Image

* [openSuSE](https://github.com/arm64v8/opensuse)

### Installation

1. Install [Docker for Raspberry Pi](http://blog.hypriot.com/).

2. Download from [Docker Hub](https://hub.docker.com/u/azcoigreach/):

    `docker pull azcoigreach/rpi-mongo`

3. Alternatively, you can build an image from Dockerfile (**In you Raspberry Pi**):

    1. `docker build --cpuset-cpus 0-3 -t="azcoigreach/rpi-mongo" github.com/azcoigreach/rpi-mongo`

### Usage

1. Run `mongod`:

    `docker run -it -p 27017:27017 -p 28017:28017 -v /data/db:/data/db -v /data/dbconfig:/data/dbconfig --restart unless-stopped --name mongodb azcoigreach/rpi-mongo`

2. For more usage details, please refer to [mongo](https://hub.docker.com/_/mongo/).