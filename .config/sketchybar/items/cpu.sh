#!/bin/bash

sketchybar --add item cpu e \
           --set cpu  update_freq=2 \
                      icon=􀫥  \
                      background.border_color=$BLUE \
                      script="$PLUGIN_DIR/cpu.sh"
