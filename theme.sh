#!/bin/bash
THEME=themes/${1:-dracula}.theme
echo "$THEME"
grep -Eq '.{5,}' <$THEME || { echo "theme not valid" && exit 1; }

# input color
sed -i 's/\[INPUT\].*,/[INPUT] = "#'"$(head -1 <$THEME)"'",/' config.def.h
# wrong pw color
sed -i 's/\[FAILED\].*,/[FAILED] = "#'"$(tail -1 <$THEME)"'",/' config.def.h
