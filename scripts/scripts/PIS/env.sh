#! /bin/bash

mihomo_dir="$HOME/.config/mihomo"

mkdir -p $HOME/.config

cp -Rf /Volumes/KaiFiles/mihomo $mihomo_dir

chmod +x "$mihomo_dir/mihomo"
xattr -r -d com.apple.quarantine "$mihomo_dir/mihomo" 2>/dev/null
codesign --force --deep -s - "$mihomo_dir/mihomo" 2>/dev/null
sudo -v
sudo -b "$mihomo_dir/mihomo" -d "$mihomo_dir" >/dev/null 2>&1
sleep 5
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
