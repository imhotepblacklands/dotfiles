#!/bin/bash

# Fetch cellular info with error suppression
# termux-telephony-cellinfo returns a JSON array of cell objects
CELL_JSON=$(termux-telephony-cellinfo 2>/dev/null)

# Process Cellular Data
# select(.registered == true) handles the active connection
# head -n 1 ensures we only get one result if multiple are registered
CELL=$(echo "$CELL_JSON" | jq -r '.[] | select(.registered == true) | "\(.type | ascii_upcase) \(.dbm)dBm"' 2>/dev/null | head -n 1)

# Fallback if no registered cell is found in the JSON or if response is empty
if [[ -z "$CELL" || "$CELL_JSON" == "[]" ]]; then
    CELL="No Signal"
fi

# Fetch Wi-Fi Data
WIFI_JSON=$(termux-wifi-connectioninfo 2>/dev/null)
SSID=$(echo "$WIFI_JSON" | jq -r '.ssid' 2>/dev/null)
RSSI=$(echo "$WIFI_JSON" | jq -r '.rssi' 2>/dev/null)

# Hiding Logic: Only shows Wi-Fi if SSID is valid and not "null" or "<unknown ssid>"
if [[ -z "$SSID" || "$SSID" == "null" || "$SSID" == "<unknown ssid>" ]]; then
    WIFI_OUTPUT=""
else
    WIFI_OUTPUT=" | ${SSID} ${RSSI}dBm"
fi

# Final Output String
echo "${CELL}${WIFI_OUTPUT}"
