#!/bin/bash

if (setxkbmap -query | grep -q "layout:\s\+us"); then
	setxkbmap -layout hu
else
	setxkbmap -layout us
fi
