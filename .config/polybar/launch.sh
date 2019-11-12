#!/usr/bin/env sh

log() {
    logger -t polybar "$1"
}

$HOME/.config/polybar/kill.sh

MONITORS=(${MONITORS:-$(xrandr --listactivemonitors | tail -n +2 | awk '{print $4}')})

for m in "${MONITORS[@]}"; do
    log "$m polybar -r desktops &"
    MONITOR=$m polybar -r desktops &
    log "$m polybar -r tray &"
    MONITOR=$m polybar -r tray &

    if [ "$(hostname)" == "yoda" ]; then
        log "$m polybar -r mpd &"
        MONITOR=$m polybar -r mpd &
    fi
done

