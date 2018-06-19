# azcoigreach/rpi-mongo Dockerfile.
#
# https://github.com/azcoigreach/rpi-mongo
#
# ARM64[aach64] openSuSE build for Raspberry Pi 3+
# 
# Requires openSuSE 64bit base OS.  There is no official 64bit Raspibian as of June 2018.


# Pull base image.
FROM arm64v8/opensuse:42.3

# Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added.
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# # Install build prerequisits
RUN zypper in -y git zlib-devel python awk libffi-devel gcc6-c++ gcc6 wget tar && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 30 --slave /usr/bin/g++ g++ /usr/bin/g++-6 && \
    cd \tmp && \
    wget http://prdownloads.sourceforge.net/scons/scons-2.5.1.tar.gz && \
    tar xvf scons-2.5.1.tar.gz && \
    cd scons-2.5.1 && \
    python setup.py install scons

# clone mongo 3.4.14
RUN cd /tmp && \
    git clone --branch r3.4.14 https://github.com/mongodb/mongo.git

# build mongo 3.4.14
RUN cd /tmp/mongo && \
    scons --disable-warnings-as-errors \
    --prefix=/tmp/mongo \
    --js-engine=mozjs \
    -Q MONGO_VERSION=3.4.14 \
    mongo mongod 

# Configuration.
RUN mkdir -p /data/db /data/configdb \
    && chown -R mongodb:mongodb /data/db /data/configdb

# Define mountable directories.
VOLUME /data/db /data/configdb

# Define working directory.
WORKDIR /data

# Expose ports.
# 	- 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017

# Define default command.
CMD ["mongod"]
