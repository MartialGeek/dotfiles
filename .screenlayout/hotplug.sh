#!/usr/bin/env bash

export DISPLAY=:0

set -e

MONITOR_INTERNAL='eDP-1'
MONITOR_1='DP-1-1'
MONITOR_2='DP-1-2'
XRANDR="xrandr --output ${MONITOR_INTERNAL} --primary --mode 1920x1080 --pos 0x616"

function log {
    logger -t hotplug "$1"
}

function is_monitor_connected {
    xrandr | grep $1 | grep '\bconnected' >> /dev/null
    echo $?
}

log "The monitors setup has changed"

sleep 0.5

XRANDR="${XRANDR} --output ${MONITOR_1}"
is_detected=$(is_monitor_connected ${MONITOR_1})

if [ "${is_detected}" -eq 0 ]; then
    log "${MONITOR_1} detected"
    XRANDR="${XRANDR} --mode 1920x1080 --pos 3840x0"
else
    XRANDR="${XRANDR} --off"
fi

XRANDR="${XRANDR} --output ${MONITOR_2}"
is_detected=$(is_monitor_connected ${MONITOR_2})

if [ "${is_detected}" -eq 0 ]; then
    log "${MONITOR_2} detected"
    XRANDR="${XRANDR} --mode 1920x1080 --pos 1920x0"
else
    XRANDR="${XRANDR} --off"
fi

log "Running command ${XRANDR}"
eval ${XRANDR}

