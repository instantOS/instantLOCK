#!/usr/bin/env bash

make clean &>/dev/null

THEME=themes/${1:-dracula}.theme
echo "$THEME"
grep -Eq '.{5,}' <$THEME || { echo "theme not valid" && exit 1; }

# input color
sed -i 's/\[INPUT\].*,/[INPUT] = "#'"$(head -1 <$THEME)"'",/' config.def.h
# wrong pw color
sed -i 's/\[FAILED\].*,/[FAILED] = "#'"$(tail -1 <$THEME)"'",/' config.def.h

# fix font
if command -v slock &>/dev/null; then
    if slock -f 2>&1 >/dev/null | grep -q '6x10'; then
        sed -i 's/font_name = ".*"/font_name = "6x10"/' config.def.h
    else
        sed -i 's/font_name = ".*"/font_name = "6x13"/' config.def.h
    fi
fi

if [ -z "$2" ]; then
    rm config.h &>/dev/null
    make
    sudo make install
fi
