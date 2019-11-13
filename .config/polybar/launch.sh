#!/usr/bin/env sh

log() {
    logger -t polybar "${@}"
}

log_and_run() {
    cmd="${@}"
    log "Running: ${cmd}"
    eval "${cmd}"
}

$HOME/.config/polybar/kill.sh

MONITORS=(${MONITORS:-$(xrandr --listactivemonitors | tail -n +2 | awk '{print $4}')})

for m in "${MONITORS[@]}"; do
    log_and_run MONITOR=$m polybar -r desktops &
    log_and_run MONITOR=$m polybar -r tray &

    if [ "$(hostname)" == "yoda" ]; then
        log_and_run MONITOR=$m polybar -r mpd &
    fi
done

