#!/bin/bash

sketchybar --add item cpu e \
           --set cpu  update_freq=2 \
                      icon=􀫥  \
                      script="$PLUGIN_DIR/cpu.sh"
