#!/usr/bin/env bash

BG_PATH="${HOME}/.config/wallpaper/bg"

if [ ! -d $(dirname ${BG_PATH}) ]
then
    mkdir -p ${BG_PATH}
fi

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

