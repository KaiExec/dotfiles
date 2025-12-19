#!/bin/bash

MEM_USED=$(top -l 1 | grep "PhysMem" | awk '{print $2}')

# memory_pressure for "System-wide memory free percentage"
# Calculate memory pressure
PERCENTAGE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{ printf("%d\n", 100 - $5) }')

COLOR=0xff9ece6a # Green
if [ "$PERCENTAGE" -gt 70 ]; then
  COLOR=0xfff7768e # Red
elif [ "$PERCENTAGE" -gt 40 ]; then
  COLOR=0xffe0af68 # Yello
fi

sketchybar --set $NAME label="${MEM_USED} (${PERCENTAGE}%)" \
                       label.color=$COLOR
