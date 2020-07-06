#!/bin/bash

# fix font
if command -v instantlock &>/dev/null; then
    if instantlock -f 2>&1 >/dev/null | grep -q '10x20'; then
        sed -i 's/font_name = ".*"/font_name = "10x20"/' config.def.h
    else
        sed -i 's/font_name = ".*"/font_name = "10x20"/' config.def.h
    fi
fi