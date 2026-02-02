#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Get all monitors
sketchybar --add event aerospace_workspace_change
MONITORS=$(aerospace list-monitors | awk '{print $1}')
WORKSPACES=$(aerospace list-workspaces --all)

for m in $MONITORS; do
  SPACE_ITEMS=()
  for sid in $WORKSPACES; do
    full_item_name="space.$sid.$m"
    SPACE_ITEMS+=("$full_item_name")
    
    sketchybar --add item "$full_item_name" left \
               --set "$full_item_name" \
                    display=$m \
                    icon="$sid" \
                    icon.color=$GREY \
                    icon.padding_left=8 \
                    icon.padding_right=8 \
                    icon.font.style="Bold" \
                    label.drawing=off \
                    background.drawing=off \
                    click_script="aerospace workspace $sid"
  done

  # Bracket for workspaces
  sketchybar --add bracket spaces_bracket.$m "${SPACE_ITEMS[@]}" \
             --set spaces_bracket.$m \
                  display=$m \
                  background.color=$BACKGROUND_1 \
                  background.border_color=$BACKGROUND_2 \
                  background.border_width=2 \
                  background.height=26 \
                  background.corner_radius=9

  # Separator (Arrow)
  sketchybar --add item space_separator.$m left \
             --set space_separator.$m \
                  display=$m \
                  icon=􀆊 \
                  icon.font="$FONT:Heavy:16.0" \
                  icon.padding_left=10 \
                  icon.padding_right=10 \
                  label.drawing=off \
                  icon.color=$WHITE

  # Apps item
  sketchybar --add item space_apps.$m left \
             --set space_apps.$m \
                  display=$m \
                  label.font="sketchybar-app-font:Regular:16.0" \
                  label.padding_left=10 \
                  label.padding_right=10 \
                  icon.drawing=off \
                  background.drawing=off \
                  script="$PLUGIN_DIR/spaces.sh" \
             --subscribe space_apps.$m aerospace_workspace_change

  # Bracket for apps
  sketchybar --add bracket apps_bracket.$m space_apps.$m \
             --set apps_bracket.$m \
                  display=$m \
                  background.color=$BACKGROUND_1 \
                  background.border_color=$BACKGROUND_2 \
                  background.border_width=2 \
                  background.height=26 \
                  background.corner_radius=9
done