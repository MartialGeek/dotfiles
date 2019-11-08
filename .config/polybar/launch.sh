#!/usr/bin/env sh

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

X_BG=$(xrdb -query | grep color0 | tail -1 | cut -d"#" -f2)

for m in $(xrandr --listactivemonitors | tail -n2 | awk '{print $4}'); do
    MONITOR=$m BG="#aa${X_BG}" polybar -r main &
done

