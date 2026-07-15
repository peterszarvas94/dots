#!/bin/bash

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  echo '{"text": "<b>REC</b> ON", "tooltip": "Stop recording", "class": "active"}'
else
  echo '{"text": ""}'
fi
