#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar $HOME/.config/polybar/config >>/tmp/polybar.log 2>&1 &
polybar top
echo "Bars launched..."
