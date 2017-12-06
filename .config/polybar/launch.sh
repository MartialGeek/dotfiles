#!/usr/bin/env sh

killall -q polybar
while pgreg -u $UID -x polybar > /dev/null; do sleep 1; done

for m in $(xrandr --query | grep '\bconnected' | cut -d " " -f1); do
    MONITOR=$m polybar -r default &
done

echo "Bar launched..."

