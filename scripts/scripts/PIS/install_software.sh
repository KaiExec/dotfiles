#!/bin/bash

DMG_DIR="$HOME/dotfiles/repro/dmg"
mkdir -p "$DMG_DIR"

IFS=$'\n'

for url in $(cat $HOME/dotfiles/repro/url)
do
    curl -L $url -O --output-dir $HOME/dotfiles/repro/dmg/
done

unset IFS

TEMP_MOUNT="/tmp/dmg_mount_point"
mkdir -p "$TEMP_MOUNT"

for pack in "$DMG_DIR"/*.dmg; do
    echo "$pack Setup..."
    yes | hdiutil attach "$pack" -mountpoint "$TEMP_MOUNT" -nobrowse -noverify
    cp -Rf "$TEMP_MOUNT"/*.app /Applications/
    hdiutil detach "$TEMP_MOUNT"
done

rmdir "$TEMP_MOUNT"

brew bundle --file="$HOME/dotfiles/repro/Brewfile"
