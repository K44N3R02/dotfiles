#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=􀧞     \
                          update_freq=5 \
                          script="$PLUGIN_DIR/calendar.sh" \
                          background.border_color=$RED \
                          background.drawing=on
