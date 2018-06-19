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

# Install build prerequisits
RUN zypper in -y git scons zlib-devel python awk libffi-devel gcc-c++ make wget tar

# Build gcc 5.3.0
RUN cd /tmp && \
    wget ftp://gcc.gnu.org/pub/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.bz2 && \
    tar xjf gcc-5.3.0.tar.bz2 && \
    ./contrib/download_prerequisites && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/opt/gcc-5.3.0 \
        --enable-languages="c,c++,go" --enable-shared --with-system-zlib \
        --enable-threads=posix --enable-__cxa_atexit --enable-checking \
        --enable-gnu-indirect-function --disable-multilib --disable-bootstrap && \
    make && \
    make install

# Build mongo 3.4.14
RUN cd /tmp && \
    git clone https://github.com/mongodb/mongo.git:r3.4.14 && \
    cd /tmp/mongo && \
    scons --disable-warnings-as-errors \
    --prefix=/tmp/mongo-build/mongo \
    --js-engine=mozjs mongo mongod MONGO_VERSION=3.4.14

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
