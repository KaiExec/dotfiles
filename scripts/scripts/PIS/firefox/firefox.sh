#!/bin/bash
# Firefox Post-Install Setup
# Run once after a fresh Firefox installation.

set -euo pipefail

FIREFOX_APP="/Applications/Firefox.app"
FF_SUPPORT="$HOME/Library/Application Support/Firefox"
PROFILE_NAME="main.default-release"
PROFILE_DIR="$FF_SUPPORT/Profiles/$PROFILE_NAME"
STARTPAGE="http://127.0.0.1:8080/startpage.html"

echo "=== Firefox Post-Install ==="

# ── 1. Profile directory ────────────────────────────────────────────────────
mkdir -p "$PROFILE_DIR/chrome"
echo "[1] Profile directory ready: $PROFILE_DIR"

# ── 2. profiles.ini ─────────────────────────────────────────────────────────
cat > "$FF_SUPPORT/profiles.ini" << EOF
[Profile0]
Name=default-release
IsRelative=1
Path=Profiles/$PROFILE_NAME
Default=1

[General]
StartWithLastProfile=1
Version=2

[Install2656FF1E876E9973]
Default=Profiles/$PROFILE_NAME
Locked=1
EOF
echo "[2] profiles.ini written"

# ── 3. user.js ──────────────────────────────────────────────────────────────
cat > "$PROFILE_DIR/user.js" << EOF
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "$STARTPAGE");
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.privatebrowsing.autostart", false);
EOF
echo "[3] user.js written"

# ── 4. userChrome.css ───────────────────────────────────────────────────────
cat > "$PROFILE_DIR/chrome/userChrome.css" << 'EOF'
#navigator-toolbox {
    margin-top: -70px !important;
    transition: margin-top 0.1s ease-in-out !important;
}

#navigator-toolbox:hover,
#navigator-toolbox:focus-within {
    margin-top: 0px !important;
    transition-delay: 0s !important;
}

/* Cmd+L 键盘聚焦时瞬间到位，防止推荐面板在 toolbar 动画期间定位错误 */
#navigator-toolbox:focus-within:not(:hover) {
    transition-duration: 0s !important;
}

/* ── 垂直 tab 序号徽标（对应 Cmd+1–9）───────────────────────────────────
   Cmd+1–8 精确跳到第 1–8 个 tab；Cmd+9 跳到最后一个 tab。
   数字 1–9 标注在前 9 个 tab 图标左上角，collapsed / expanded 状态均可见。 */

#tabbrowser-tabs[orient="vertical"] {
    counter-reset: vtab-num;
}

#tabbrowser-tabs[orient="vertical"] .tabbrowser-tab {
    counter-increment: vtab-num;
}

#tabbrowser-tabs[orient="vertical"]
    .tabbrowser-tab:nth-child(-n+9 of .tabbrowser-tab)
    .tab-content {
    position: relative;
}

#tabbrowser-tabs[orient="vertical"]
    .tabbrowser-tab:nth-child(-n+9 of .tabbrowser-tab)
    .tab-content::before {
    content: counter(vtab-num);
    position: absolute;
    top: 1px;
    left: 1px;
    z-index: 10;
    pointer-events: none;
    font-size: 8px;
    font-weight: 700;
    line-height: 1;
    padding: 1px 3px;
    border-radius: 3px;
    color: #fff;
    background: rgba(0, 0, 0, 0.5);
}
EOF
echo "[4] userChrome.css written"

# ── 5. Patch browser/omni.ja (disable URL bar focus on new tab) ─────────────
echo "[5] Patching browser/omni.ja..."
BROWSER_OMNI="$FIREFOX_APP/Contents/Resources/browser/omni.ja"
WORK_DIR=$(mktemp -d)

cp "$BROWSER_OMNI" "${BROWSER_OMNI}.backup"
unzip -q -o "$BROWSER_OMNI" -d "$WORK_DIR" 2>/dev/null || true

python3 - "$WORK_DIR" << 'PYEOF'
import sys

workdir = sys.argv[1]

# Patch 1: URILoadingHelper.sys.mjs — Cmd+T new tab
f = workdir + "/modules/URILoadingHelper.sys.mjs"
content = open(f).read()
old = ("        focusUrlBar =\n"
       "          !loadInBackground &&\n"
       "          w.isBlankPageURL(url) &&\n"
       "          !lazy.AboutNewTab.willNotifyUser;")
new = "        focusUrlBar = false;"
if old in content:
    open(f, "w").write(content.replace(old, new, 1))
    print("  patched URILoadingHelper.sys.mjs")
else:
    print("  WARNING: URILoadingHelper pattern not found (Firefox version changed?)")

# Patch 2: tabbrowser.js — adjacent new tab button
f = workdir + "/chrome/browser/content/browser/tabbrowser/tabbrowser.js"
content = open(f).read()
old = "              focusUrlBar: true,"
new = "              focusUrlBar: false,"
if old in content:
    open(f, "w").write(content.replace(old, new, 1))
    print("  patched tabbrowser.js")
else:
    print("  WARNING: tabbrowser pattern not found (Firefox version changed?)")
PYEOF

(cd "$WORK_DIR" && zip -q -r -0 /tmp/_ff_browser_omni.ja . 2>/dev/null)
mv /tmp/_ff_browser_omni.ja "$BROWSER_OMNI"
rm -rf "$WORK_DIR"
echo "     browser/omni.ja replaced"

# ── 6. 扩展相关文件（工具栏布局、权限、存储）────────────────────────────────
# 从旧 profile 迁移时需要手动补充；全新安装时此步骤跳过（文件不存在）。
OLD_PROFILE=""
for d in "$HOME/Library/Application Support/Firefox/Profiles"/*/; do
  name=$(basename "$d")
  if [ "$name" != "$PROFILE_NAME" ] && [ -f "${d}places.sqlite" ]; then
    OLD_PROFILE="$d"
    break
  fi
done

if [ -n "$OLD_PROFILE" ]; then
  echo "[6] Migrating extension files from $OLD_PROFILE..."
  for f in xulstore.json extension-settings.json; do
    [ -f "${OLD_PROFILE}$f" ] && cp "${OLD_PROFILE}$f" "$PROFILE_DIR/$f" && echo "     ✓ $f"
  done
  for d in extension-store extension-store-menus extension-store-userscripts; do
    [ -d "${OLD_PROFILE}$d" ] && cp -R "${OLD_PROFILE}$d" "$PROFILE_DIR/$d" && echo "     ✓ $d/"
  done
else
  echo "[6] No source profile found, skipping extension file migration"
fi

# ── 7. Tridactyl — newtab ───────────────────────────────────────────────────
# Requires Tridactyl native messenger: run :installnative inside Firefox first.
TRIDACTYL_RC="$HOME/.config/tridactyl/tridactylrc"
mkdir -p "$(dirname "$TRIDACTYL_RC")"
if [ -f "$TRIDACTYL_RC" ]; then
    if grep -q "^set newtab" "$TRIDACTYL_RC"; then
        sed -i '' "s|^set newtab.*|set newtab $STARTPAGE|" "$TRIDACTYL_RC"
    else
        echo "set newtab $STARTPAGE" >> "$TRIDACTYL_RC"
    fi
    if grep -q "^set modeindicator" "$TRIDACTYL_RC"; then
        sed -i '' "s|^set modeindicator.*|set modeindicator false|" "$TRIDACTYL_RC"
    else
        echo "set modeindicator false" >> "$TRIDACTYL_RC"
    fi
else
    echo "set newtab $STARTPAGE" > "$TRIDACTYL_RC"
    echo "set modeindicator false" >> "$TRIDACTYL_RC"
fi
echo "[7] Tridactyl newtab + modeindicator set in $TRIDACTYL_RC"

# ── 8. Clear startup cache ───────────────────────────────────────────────────
rm -rf "$HOME/Library/Caches/Firefox/Profiles/*/startupCache/"
echo "[8] Startup cache cleared"

echo ""
echo "=== Done. Start Firefox to apply. ==="
echo "    Reminder: run :installnative in Tridactyl if not already done."
