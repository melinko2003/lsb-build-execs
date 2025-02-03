#!/bin/bash

# Package Management
apt-get update -y
apt-get install -y software-properties-common cmake libmariadb-dev-compat libluajit-5.1-dev \
        libzmq3-dev zlib1g-dev libssl-dev binutils-dev curl jq git gcc-14 g++-14 libgcc-14-dev
apt-get clean

set -x
# XLTD Auctioneer Vars
AUCTIONEER_PATH="/opt/ffxi/auctioneer"
BACKUP_PATH="/opt/ffxi/lsb-backup"
# Server Vars
SERVER_PATH="/opt/ffxi/server"
SERVER_SETTINGS_PATH="${SERVER_PATH}/settings"
SERVER_TOOLS_PATH="${SERVER_PATH}/tools"
SERVER_LOG_PATH="${SERVER_PATH}/log" 
SERVER_BUILD_PATH="/opt/build/"

# Keep checking every 20 seconds until the file exists
while [ ! -f "$SERVER_PATH/navmeshes/49.nav" ]; do
    echo "Waiting for $SERVER_PATH to be created..."
    sleep 20
done

pushd $SERVER_PATH
VERSION_HASH=$(git log -1 --pretty=format:"%h")
if [ ! -d $BACKUP_PATH/$VERSION_HASH ]; then
    export CC=/usr/bin/gcc-14
    export CXX=/usr/bin/g++-14
    sed -i 's/if ((c >= 0 && c <= 0x20) || c >= 0x7F)/if (!std::isprint(static_cast<unsigned char>(c)))/' src/map/lua/luautils.cpp
    if [ $(uname -p) = "x86_64" ]; then CFLAGS=-m64 CXXFLAGS=-m64 LDFLAGS=-m64 cmake -S . -B $SERVER_BUILD_PATH ; fi
    if [ $(uname -p) = "aarch64" ]; then cmake -S . -B $SERVER_BUILD_PATH ; fi
    cmake --build $SERVER_BUILD_PATH -j4
# curl -sLO $(curl -s "https://api.github.com/repos/LandSandBoat/xiloader/releases" | jq -r '.[0].assets.[].browser_download_url')
    chmod +x xi_*
    mkdir -p $BACKUP_PATH/$VERSION_HASH
    cp xi_* $BACKUP_PATH/$VERSION_HASH/
else
    cp $BACKUP_PATH/$VERSION_HASH/xi_* .
fi