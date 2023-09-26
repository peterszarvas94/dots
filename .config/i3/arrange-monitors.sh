#!/bin/bash

big="HDMI-1"
small="eDP-1"

if xrandr --query | grep "$big connected"; then
  xrandr --output $big --primary --mode 2560x1080 --pos 0x0 --rotate normal --output $small --mode 1920x1080 --pos 320x1080 --rotate normal
  # xrandr --output $big --primary --mode 2560x1080 --pos 0x0 --rotate normal --output $small --off
else
  if xrandr --query | grep "$small connected"; then
    xrandr --output $small --mode 1920x1080 --pos 0x0 --rotate normal --output $big --off
  fi
fi
