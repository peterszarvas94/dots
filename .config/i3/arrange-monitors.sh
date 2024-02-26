#!/bin/bash

big="HDMI-1"
small="eDP-1"

# check if the big monitor is connected
big_connected=$(xrandr --query | grep "$big connected")

# if big is not connected, quit
if [ -z "$big_connected" ]; then
  exit 0
fi

# check if big is active
big_is_active=$(xrandr --listactivemonitors | grep "$big" | wc -l)
echo $big_is_active

# check if small is active
small_is_active=$(xrandr --listactivemonitors | grep "$small" | wc -l)
echo $small_is_active

# 3 stage: only big, only small, both
if [ $big_is_active -eq 1 ] && [ $small_is_active -eq 1 ]; then
  xrandr --output $big --primary --mode 2560x1080 --pos 0x0 --rotate normal --output $small --off
  polybar -r big
elif [ $big_is_active -eq 1 ] && [ $small_is_active -eq 0 ]; then
  xrandr --output $small --mode 1920x1080 --pos 0x0 --rotate normal --output $big --off
  polybar -r small
elif [ $big_is_active -eq 0 ] && [ $small_is_active -eq 1 ]; then
  xrandr --output $big --primary --mode 2560x1080 --pos 0x0 --rotate normal --output $small --mode 1920x1080 --pos 320x1080 --rotate normal
  polybar -r big
  polybar -r small
fi
