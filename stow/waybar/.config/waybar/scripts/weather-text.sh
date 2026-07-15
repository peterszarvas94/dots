#!/bin/bash

weather=$(curl -fsS --max-time 4 "https://wttr.in?format=j1" 2>/dev/null | jq -er '.current_condition[0] | "\(.temp_C)|\(.weatherDesc[0].value)"' 2>/dev/null) || weather=""

if [[ -z $weather ]]; then
  printf '{"text":"","class":"unavailable"}\n'
  exit 0
fi

IFS='|' read -r temp condition <<< "$weather"
condition=$(tr '[:lower:]' '[:upper:]' <<< "$condition")

printf '{"text":"<b>OUT</b> %s°C %s"}\n' "$temp" "$condition"
