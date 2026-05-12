#!/bin/bash
# patch-lyrics-plus.sh
# 修改 Spotify Lyrics Plus，将 Netease 歌词源替换为本地 NCM API 代理
# 并注入楷体字体到歌词区域

set -e

TARGET="/Applications/Spotify.app/Contents/Resources/Apps/xpui/spicetify-routes-lyrics-plus.js"
BACKUP="${TARGET}.bak"

# ── 1. 检查文件存在 ────────────────────────────────────────────────────────────
if [ ! -f "$TARGET" ]; then
  echo "❌ 找不到文件：$TARGET"
  echo "   请确认 Spotify 已安装，且 Spicetify 已执行过 backup apply"
  exit 1
fi

# ── 2. 备份（仅首次） ─────────────────────────────────────────────────────────
if [ ! -f "$BACKUP" ]; then
  cp "$TARGET" "$BACKUP"
  echo "✅ 已备份原始文件：$BACKUP"
else
  echo "ℹ️  备份已存在，跳过备份"
fi

# ── 3. 从备份还原（保证幂等，每次从干净状态开始修改） ─────────────────────────
cp "$BACKUP" "$TARGET"
echo "✅ 已从备份还原干净文件"

# ── 4. 替换 Netease API URL ───────────────────────────────────────────────────
sed -i '' \
  's|https://music.xianqiao.wang/neteaseapiv2/|http://127.0.0.1:8912/|g' \
  "$TARGET"
echo "✅ 已替换 Netease API URL -> 127.0.0.1:8912"

# ── 5. 注入楷体字体到歌词区域（用 Python 避免 sed 换行问题） ──────────────────
FONT_INJECT=';(function(){const s=document.createElement("style");s.textContent=`[class*="LyricsLine"],[class*="Karaoke-Word"],[class*="Performer"],[class*="SyncedLyrics"]{font-family:"Kaiti SC","STKaiti","Kai",serif !important;}`;document.head.appendChild(s);})();'

python3 - <<PYEOF
with open("$TARGET", "r", encoding="utf-8") as f:
    content = f.read()
inject = '$FONT_INJECT'
if inject not in content:
    content = inject + "\n" + content
with open("$TARGET", "w", encoding="utf-8") as f:
    f.write(content)
PYEOF
echo "✅ 已注入楷体字体样式"

# ── 6. 验证 ───────────────────────────────────────────────────────────────────
echo ""
echo "── 验证结果 ──────────────────────────────────────────────────────────────"
grep -n "127.0.0.1\|xianqiao" "$TARGET" | head -5
echo ""
echo "✅ 完成。请重启 Spotify。"
echo ""
echo "⚠️  注意：首次运行需在 Spotify DevTools Console 执行一次："
echo "   localStorage.setItem(\"spicetify:corsProxyTemplate\", \"{url}\");"
echo "   之后无需重复。"
