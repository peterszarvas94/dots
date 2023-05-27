#!/usr/bin/env bash

#polybar-msg cmd quit

killall polybar

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar big 2>&1 | tee -a /tmp/polybar1.log & disown
polybar small 2>&1 | tee -a /tmp/polybar2.log & disown

# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload bar1 &
#   done
# else
#   polybar --reload example &
# fi

echo "Bars launched..."
