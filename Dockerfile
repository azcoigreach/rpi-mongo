# azcoigreach/rpi-mongo Dockerfile.
#
# https://github.com/azcoigreach/rpi-mongo
#
# ARM64[aach64] openSuSE build for Raspberry Pi 3+
# 
# Requires openSuSE 64bit base OS.  There is no official 64bit Raspibian as of June 2018.


# Pull base image.
FROM aarch64/opensuse:42.2

# Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added.
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# Install MongoDB & remove proxy.
RUN zypper in mongodb-org-server
    
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
