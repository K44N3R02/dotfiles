#!/bin/bash

source "$CONFIG_DIR/colors.sh"

update_spaces() {
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  ALL_WORKSPACES=$(aerospace list-workspaces --all)
  MONITORS=$(aerospace list-monitors | awk '{print $1}')

  for sid in $ALL_WORKSPACES; do
    APPS_IN_SPACE=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{print $2}' | grep -v "Window Title" | xargs)
    
    COLOR=$GREY
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      COLOR=$RED
    elif [ -n "$APPS_IN_SPACE" ]; then
      COLOR=$GREEN
    fi

    for m in $MONITORS; do
      sketchybar --set "space.$sid.$m" icon.color=$COLOR
    done
  done
}

update_apps() {
  # If CPU is hidden (Zen mode), do nothing to the app strip
  ZEN_MODE=$(sketchybar --query cpu | jq -r ".geometry.drawing")
  if [ "$ZEN_MODE" = "off" ]; then
    return
  fi

  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  MONITORS=$(aerospace list-monitors | awk '{print $1}')
  
  APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | grep -v "Window Title" | grep -v "^$")
  
  ICON_STRIP=""
  if [ -n "$APPS" ]; then
    while read -r app; do
      if [ -n "$app" ]; then
        ICON=$($CONFIG_DIR/plugins/icon_map.sh "$app")
        ICON_STRIP+="$ICON "
      fi
    done <<< "$APPS"
  else
    ICON_STRIP=" —"
  fi

  for m in $MONITORS; do
    sketchybar --set "space_apps.$m" label="$ICON_STRIP"
  done
}

update_spaces
update_apps
