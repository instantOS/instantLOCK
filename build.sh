#!/usr/bin/env bash

make clean &>/dev/null

./theme.sh "$1"
./prepare.sh

if [ -z "$2" ]; then
    rm config.h &>/dev/null
    make
    sudo make install
fi
