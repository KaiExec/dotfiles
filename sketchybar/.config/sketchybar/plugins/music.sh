#!/bin/bash

INFO=$(fastfetch --logo none --separator " " --structure Media --key-type none)

if [[ "$INFO" == *"Playing"* ]]; then
    sketchybar --set $NAME label="$INFO" drawing=on label.color=0xFF1AFF25
elif [[ "$INFO" == *"Paused"* ]]; then
    sketchybar --set $NAME label="$INFO" drawing=on label.color=0xFF91AFCF
else
    sketchybar --set $NAME drawing=off
fi
