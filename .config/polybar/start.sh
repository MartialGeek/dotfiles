#!/usr/bin/env bash

killall polybar

X_BG=$(xrdb -query | grep color0 | tail -1 | cut -d"#" -f2)
BG="#aa${X_BG}" polybar soad

