#!/bin/bash
# patch-lyrics-to-web.sh
# Spotify 更新后重新注入 lyrics-to-web 扩展，并确保服务器 LaunchAgent 在位
# 幂等：可重复运行

set -e

SPICETIFY="/opt/homebrew/bin/spicetify"
EXT_SRC="$HOME/.config/spicetify/Extensions/lyrics-to-web.js"
PLIST_SRC="$HOME/scripts/PUS/Spotify/com.user.lyrics-wall.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.lyrics-wall.plist"

# ── 1. 检查依赖 ────────────────────────────────────────────────────────────────
if [ ! -x "$SPICETIFY" ]; then
  echo "❌ 找不到 spicetify：$SPICETIFY"
  exit 1
fi

if [ ! -f "$EXT_SRC" ]; then
  echo "❌ 扩展源文件不存在：$EXT_SRC"
  exit 1
fi

if [ ! -f "/Applications/Spotify.app/Contents/Resources/Apps/xpui/xpui.js" ] && \
   [ ! -d "/Applications/Spotify.app/Contents/Resources/Apps/xpui" ]; then
  echo "❌ 找不到 Spotify xpui 目录，请确认 Spotify 已安装"
  exit 1
fi

# ── 2. 注入扩展 ────────────────────────────────────────────────────────────────
echo "▸ 注入 lyrics-to-web 扩展..."
"$SPICETIFY" config extensions lyrics-to-web.js
"$SPICETIFY" apply
echo "✅ Spicetify apply 完成"

# ── 3. 确保 LaunchAgent 在位并已加载 ──────────────────────────────────────────
if [ ! -f "$PLIST_SRC" ]; then
  echo "⚠️  未找到 LaunchAgent plist：$PLIST_SRC，跳过服务器部分"
else
  cp "$PLIST_SRC" "$PLIST_DEST"
  launchctl unload "$PLIST_DEST" 2>/dev/null || true
  launchctl load   "$PLIST_DEST"
  echo "✅ LaunchAgent com.user.lyrics-wall 已加载"
fi

echo ""
echo "✅ 完成。请重启 Spotify。"
