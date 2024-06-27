#!/bin/bash

layout=$(setxkbmap -query | awk '/layout/{print $2}')

if [ "$layout" = "us" ]; then
	echo "US"
else
	echo "HU"
fi
