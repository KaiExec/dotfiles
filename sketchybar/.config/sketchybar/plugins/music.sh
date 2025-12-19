#!/bin/bash

INFO=$(fastfetch --logo none --separator " " --structure Media --key-type none)

if [[ "$INFO" == *"Playing"* ]]; then
    sketchybar --set $NAME label="$INFO" drawing=on label.color=0xFFCC5EFF
elif [[ "$INFO" == *"Paused"* ]]; then
    sketchybar --set $NAME label="$INFO" drawing=on label.color=0xFF91AFCF
else
    sketchybar --set $NAME drawing=off
fi
