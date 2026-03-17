#!/bin/bash

# Function to get cellular signal icon (Requested Bar glyphs)
# Mapping: 󰢼 (1 bar), 󰢽 (2 bars), 󰢾 (3 bars), 󰢿 (4 bars), 󰣀 (5 bars)
get_cell_bars() {
    local dbm=$1
    if [[ -z "$dbm" || "$dbm" == "null" ]]; then echo "󰢻"; return; fi
    if (( dbm >= -70 )); then echo "󰣀";      # 5 bars
    elif (( dbm >= -85 )); then echo "󰢿";    # 4 bars
    elif (( dbm >= -100 )); then echo "󰢾";   # 3 bars
    elif (( dbm >= -110 )); then echo "󰢽";   # 2 bars
    elif (( dbm >= -120 )); then echo "󰢼";   # 1 bar
    else echo "󰢻"; fi                       # 0 bars
}

# Function to get wifi signal icon (Radio Waves)
get_wifi_icon() {
    local rssi=$1
    if [[ -z "$rssi" || "$rssi" == "null" ]]; then echo "󰤯"; return; fi
    if (( rssi >= -50 )); then echo "󰤨";
    elif (( rssi >= -60 )); then echo "󰤥";
    elif (( rssi >= -70 )); then echo "󰤢";
    elif (( rssi >= -80 )); then echo "󰤟";
    else echo "󰤯"; fi
}

# Fetch cellular info with error suppression
CELL_JSON=$(termux-telephony-cellinfo 2>/dev/null)

# Extract Cellular Data
CELL_DATA=$(echo "$CELL_JSON" | jq -r '.[] | select(.registered == true) | "\(.type | ascii_upcase),\(.dbm)"' 2>/dev/null | head -n 1)

if [[ -z "$CELL_DATA" || "$CELL_JSON" == "[]" ]]; then
    CELL="󰢻 No Signal"
else
    TYPE=$(echo "$CELL_DATA" | cut -d',' -f1)
    DBM=$(echo "$CELL_DATA" | cut -d',' -f2)
    CELL_ICON=$(get_cell_bars "$DBM")
    CELL="${CELL_ICON} ${TYPE}"
fi

# Fetch Wi-Fi Data
WIFI_JSON=$(termux-wifi-connectioninfo 2>/dev/null)
SSID=$(echo "$WIFI_JSON" | jq -r '.ssid' 2>/dev/null)
RSSI=$(echo "$WIFI_JSON" | jq -r '.rssi' 2>/dev/null)

# Hiding Logic: Only shows Wi-Fi if SSID is valid and not "null" or "<unknown ssid>"
if [[ -z "$SSID" || "$SSID" == "null" || "$SSID" == "<unknown ssid>" ]]; then
    WIFI_OUTPUT=""
else
    WIFI_ICON=$(get_wifi_icon "$RSSI")
    WIFI_OUTPUT=" | ${WIFI_ICON} ${SSID}"
fi

# Final Output String
echo "${CELL}${WIFI_OUTPUT}"
