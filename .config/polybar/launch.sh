#!/usr/bin/env sh

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

for m in $(xrandr --query | grep '\bconnected' | cut -d " " -f1); do
    MONITOR=$m polybar -r desktops &
    MONITOR=$m polybar -r tray &
    MONITOR=$m polybar -r mpd &
done

