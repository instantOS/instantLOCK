#!/usr/bin/env bash

make clean &>/dev/null

THEME=themes/${1:-dracula}.theme
echo "$THEME"
grep -Eq '.{5,}' <$THEME || { echo "theme not valid" && exit 1; }

# input color
sed -i 's/\[INPUT\].*,/[INPUT] = "#'"$(head -1 <$THEME)"'",/' config.def.h
# wrong pw color
sed -i 's/\[FAILED\].*,/[FAILED] = "#'"$(tail -1 <$THEME)"'",/' config.def.h

if [ -z "$2" ]; then
    rm config.h &>/dev/null
    make
    sudo make install
fi
