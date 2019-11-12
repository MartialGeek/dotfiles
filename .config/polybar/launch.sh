#!/usr/bin/env sh

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

MONITORS=${MONITORS:-$(xrandr --listactivemonitors | tail -n +2 | awk '{print $4}')}

for m in $MONITORS; do
    MONITOR=$m polybar -r desktops &
    MONITOR=$m polybar -r tray &

    if [ "$(hostname)" == "yoda" ]; then
        MONITOR=$m polybar -r mpd &
    fi
done

