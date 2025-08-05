#!/bin/bash

sketchybar --add event wifi_event

sketchybar --add item wifi q \
           --set wifi script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi wifi_event
