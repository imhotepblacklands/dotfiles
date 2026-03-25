#!/bin/bash

# Function to get battery percentage in Termux
get_battery_percentage_termux() {
	termux-battery-status | jq .percentage
}

# Function to get charging status in Termux
get_charging_status_termux() {
	termux-battery-status | jq .status
}

# Check if running in Termux
if command -v termux-battery-status &>/dev/null; then
	battery_percentage=$(get_battery_percentage_termux)
	charging_status=$(get_charging_status_termux)
else
	# Fallback (non-termux)
	battery_percentage=100
	charging_status="DISCHARGING"
fi

# Determine the icon and color based on the battery percentage and charging status
icon=""
color=""

# Handle "CHARGING" and "FULL" as charging states
if [[ "$charging_status" == "\"CHARGING\"" ]] || [[ "$charging_status" == "\"FULL\"" ]]; then
	# Charging icons
	case $battery_percentage in
	100) icon="󰂅" color="#00FF00" ;;
	9[0-9]) icon="󰂋" color="#00FF00" ;;
	8[0-9]) icon="󰂊" color="#00FF00" ;;
	7[0-9]) icon="󰢞" color="#00FF00" ;;
	6[0-9]) icon="󰂉" color="#FFFF00" ;;
	5[0-9]) icon="󰢝" color="#FFFF00" ;;
	4[0-9]) icon="󰂈" color="#FFA500" ;;
	3[0-9]) icon="󰂇" color="#FFA500" ;;
	2[0-9]) icon="󰂆" color="#FF0000" ;;
	1[0-9]) icon="󰢜" color="#FF0000" ;;
	*) icon="󰢜" color="#FF0000" ;;
	esac
else
	# Discharging icons
	case $battery_percentage in
	100) icon="󰁹" color="#00FF00" ;;
	9[0-9]) icon="󰂂" color="#00FF00" ;;
	8[0-9]) icon="󰁿" color="#00FF00" ;;
	7[0-9]) icon="󰁾" color="#00FF00" ;;
	6[0-9]) icon="󰁽" color="#FFFF00" ;;
	5[0-9]) icon="󰁼" color="#FFFF00" ;;
	4[0-9]) icon="󰁻" color="#FFA500" ;;
	3[0-9]) icon="󰁺" color="#FFA500" ;;
	2[0-9]) icon="󰂁" color="#FF0000" ;;
	1[0-9]) icon="󰂀" color="#FF0000" ;;
	*) icon="󰁹" color="#FF0000" ;;
	esac
fi

# Output the formatted string for tmux
echo "#[fg=$color]$icon #[fg=#7aa2f7,bg=#3b4261]$battery_percentage%"
