#!/bin/bash

if pgrep -x hypridle >/dev/null; then
  echo '{"text": ""}'
else
  echo '{"text": "<b>IDL</b> OFF", "tooltip": "Idle lock disabled", "class": "active"}'
fi
