#!/bin/bash

# Function to get battery percentage in Termux
get_battery_percentage_termux() {
	termux-battery-status | jq .percentage
}

# Function to get battery percentage in standard Linux (e.g., Ubuntu)
get_battery_percentage_linux() {
	cat /sys/class/power_supply/BAT1/capacity
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
	battery_percentage=$(get_battery_percentage_linux)
	charging_status="DISCHARGING" # Assuming default is discharging
fi

# Determine the icon and color based on the battery percentage and charging status
icon=""
color=""

if [ "$charging_status" = "\"CHARGING\"" ]; then
	# Select icon for charging status
	case $battery_percentage in
	9[0-9] | 100)
		icon="󰂅"
		color="#00FF00"
		;; # Green for high battery levels
	8[0-9])
		icon="󰂋"
		color="#00FF00"
		;;
	7[0-9])
		icon="󰂊"
		color="#00FF00"
		;;
	6[0-9])
		icon="󰢞"
		color="#FFFF00"
		;; # Yellow for medium battery levels
	5[0-9])
		icon="󰂉"
		color="#FFFF00"
		;;
	4[0-9])
		icon="󰢝"
		color="#FFA500"
		;; # Orange for lower battery levels
	3[0-9])
		icon="󰂈"
		color="#FFA500"
		;;
	2[0-9])
		icon="󰂇"
		color="#FF0000"
		;; # Red for critical battery levels
	1[0-9])
		icon="󰂆"
		color="#FF0000"
		;;
	*)
		icon="󰢜"
		color="#FF0000"
		;;
	esac
else
	# Select icon for non-charging status
	case $battery_percentage in
	9[0-9] | 100)
		icon="󰂂"
		color="#00FF00"
		;;
	8[0-9])
		icon="󰁿"
		color="#00FF00"
		;;
	7[0-9])
		icon="󰁾"
		color="#00FF00"
		;;
	6[0-9])
		icon="󰁽"
		color="#FFFF00"
		;;
	5[0-9])
		icon="󰁼"
		color="#FFFF00"
		;;
	4[0-9])
		icon="󰁻"
		color="#FFA500"
		;;
	3[0-9])
		icon="󰁺"
		color="#FFA500"
		;;
	2[0-9])
		icon="󰂁"
		color="#FF0000"
		;;
	1[0-9])
		icon="󰂀"
		color="#FF0000"
		;;
	*)
		icon="󰁹"
		color="#FF0000"
		;;
	esac
fi

charging_indicator=""
if [ "$charging_status" = "\"CHARGING\"" ]; then
	charging_indicator="󱐋 "
fi

# Output the formatted string for tmux
echo "#[fg=$color]$icon #[default]$charging_indicator$battery_percentage %"
