#!/usr/bin/env sh

killall -q polybar
while pgreg -u $UID -x polybar > /dev/null; do sleep 1; done

polybar -r default &

echo "Bar launched..."

