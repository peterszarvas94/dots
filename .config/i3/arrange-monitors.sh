#!/bin/bash

if xrandr --query | grep "HDMI-A-0 connected"; then
  # xrandr --output HDMI-A-0 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output eDP --mode 1920x1080 --pos 320x1080 --rotate normal
	xrandr --output HDMI-A-0 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output eDP --off
else
  if xrandr --query | grep "eDP connected"; then
    xrandr --output eDP --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --off
  fi
fi

