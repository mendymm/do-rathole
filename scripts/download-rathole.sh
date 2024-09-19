#!/usr/bin/env bash

set -uex

if [ ! -d "bin" ]; then
    mkdir bin
fi

if [ ! -f "bin/rathole" ]; then
    # download rathole
    DL_PATH=$(mktemp)
    TMP_BIN_PATH=$(mktemp)
    wget -O $DL_PATH "https://github.com/rapiz1/rathole/releases/download/v0.5.0/rathole-x86_64-unknown-linux-gnu.zip"
    unzip -p $DL_PATH rathole > $TMP_BIN_PATH
    mv $TMP_BIN_PATH bin/rathole
    chmod 0775 bin/rathole
fi



