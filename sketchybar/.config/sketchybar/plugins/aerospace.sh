#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

ALL_WORKSPACE=$(aerospace list-workspaces --all)
ACTIVE_WORKSPACE=$(aerospace list-windows --all --format '%{workspace}' | sort -u)
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
    sketchybar --set $NAME drawing=on
elif echo "$ACTIVE_WORKSPACE" | grep -q "$1";then
    sketchybar --set $NAME background.drawing=off
else
    sketchybar --set $NAME drawing=off
    sketchybar --set $NAME background.drawing=off
fi

