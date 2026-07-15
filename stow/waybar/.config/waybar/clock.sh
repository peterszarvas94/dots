#!/usr/bin/env bash

set -euo pipefail

formatted_year=$(date '+%Y')
formatted_month=$(date '+%m')
formatted_day=$(date '+%d')
formatted_time=$(date '+%H:%M')

format_template=$(tr -d '\n' < ~/.config/waybar/clock-format.json)
printf "$format_template" "$formatted_year" "$formatted_month" "$formatted_day" "$formatted_time"
