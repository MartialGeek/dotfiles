#!/usr/bin/env bash

export DISPLAY=:0

set -e

function log {
    logger -t hotplug "$1"
}

function is_monitor_connected {
    xrandr | grep $1 | grep '\bconnected' >> /dev/null
    echo $?
}

log "The monitors setup has changed"

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
CONFIG_PATH="${SCRIPT_PATH}/config.sh"

if [ ! -f "${CONFIG_PATH}" ]; then
    log "Cannot find the script ${CONFIG_PATH}"
    exit 1
fi

. ${CONFIG_PATH}

XRANDR="xrandr --output ${PRIMARY} --primary ${MONITORS[${PRIMARY}]}"
unset MONITORS[${PRIMARY}]

sleep 0.5 

for monitor in "${!MONITORS[@]}"
do
    XRANDR="${XRANDR} --output ${monitor}"
    is_detected=$(is_monitor_connected ${monitor})

    if [ "${is_detected}" -eq 0 ]; then
        log "${monitor} detected"
        XRANDR="${XRANDR} ${MONITORS[$monitor]}"
    else
        XRANDR="${XRANDR} --off"
    fi
done

log "Running command ${XRANDR}"
eval ${XRANDR}
i3 restart

