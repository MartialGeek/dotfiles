#!/usr/bin/env sh

BG_PATH="${HOME}/.config/wallpaper/bg"

if [ -f "${BG_PATH}.jpg" ]
then
    BG_PATH="${BG_PATH}.jpg"
elif [ -f "${BG_PATH}.png" ]
then
    BG_PATH="${BG_PATH}.png"
else
    echo "No background found"
    exit 1
fi

feh --bg-scale ${BG_PATH}

