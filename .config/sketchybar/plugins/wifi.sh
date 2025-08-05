#!/bin/bash

source "$CONFIG_DIR/icons.sh"

sketchybar --set $NAME label="$DOWNLOAD$DW $UPLOAD$UP"
if [ $CON = active ]; then
  sketchybar --set $NAME icon="$WIFI_CONNECTED"
else
  sketchybar --set $NAME icon="$WIFI_DISCONNECTED"
fi
