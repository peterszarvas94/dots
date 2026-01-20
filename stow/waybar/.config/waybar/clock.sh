#!/usr/bin/env bash

set -euo pipefail

formatted_year=$(date '+%Y')
formatted_month=$(date '+%b' | tr '[:lower:]' '[:upper:]')
formatted_day=$(date '+%d')
formatted_weekday=$(date '+%a' | tr '[:lower:]' '[:upper:]')
formatted_week=$(date '+%V')
formatted_time=$(date '+%H:%M')

format_template=$(tr -d '\n' < ~/.config/waybar/clock-format.json)
printf "$format_template" "$formatted_year" "$formatted_month" "$formatted_day" "$formatted_weekday" "$formatted_week" "$formatted_time"
