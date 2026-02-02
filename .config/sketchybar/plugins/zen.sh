#!/bin/bash

zen_on() {
  # Hide right-side items
  sketchybar --set wifi label.drawing=off \
             --set cpu drawing=off \
             --set ram drawing=off \
             --set calendar icon.drawing=off \
             --set volume_icon drawing=off \
             --set volume drawing=off \
             --set battery label.drawing=off

  # Hide workspace/app items (left side)
  # Using the exact name from the query to ensure match
  sketchybar --set "/space_separator.*/" drawing=off \
             --set "/space_apps.*/" drawing=off \
             --set "/apps_bracket.*/" drawing=off
}

zen_off() {
  sketchybar --set wifi label.drawing=on \
             --set cpu drawing=on \
             --set ram drawing=on \
             --set calendar icon.drawing=on \
             --set volume_icon drawing=on \
             --set volume drawing=on \
             --set battery label.drawing=on

  # Restore left side
  sketchybar --set "/space_separator.*/" drawing=on \
             --set "/space_apps.*/" drawing=on \
             --set "/apps_bracket.*/" drawing=on
}

if [ "$1" = "on" ]; then
  zen_on
elif [ "$1" = "off" ]; then
  zen_off
else
  # Check CPU drawing state
  STATE=$(sketchybar --query cpu | jq -r ".geometry.drawing")
  if [ "$STATE" = "on" ]; then
    zen_on
  else
    zen_off
  fi
fi
