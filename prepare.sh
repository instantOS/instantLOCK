#!/bin/bash

# fix font
if command -v instantlock &>/dev/null; then
    if instantlock -f 2>&1 >/dev/null | grep -q '6x10'; then
        sed -i 's/font_name = ".*"/font_name = "6x10"/' config.def.h
    else
        sed -i 's/font_name = ".*"/font_name = "6x13"/' config.def.h
    fi
fi