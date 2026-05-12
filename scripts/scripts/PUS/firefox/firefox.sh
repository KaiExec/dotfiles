#!/bin/bash
# Firefox Post-Update
# Re-patch browser/omni.ja after every Firefox version update
# (updates overwrite the app bundle, resetting any patches).

set -euo pipefail

FIREFOX_APP="/Applications/Firefox.app"
BROWSER_OMNI="$FIREFOX_APP/Contents/Resources/browser/omni.ja"

echo "=== Firefox Post-Update ==="

# ── Re-patch browser/omni.ja (disable URL bar focus on new tab) ─────────────
echo "[1] Patching browser/omni.ja..."
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
    print("  WARNING: URILoadingHelper pattern not found — check Firefox version")

# Patch 2: tabbrowser.js — adjacent new tab button
f = workdir + "/chrome/browser/content/browser/tabbrowser/tabbrowser.js"
content = open(f).read()
old = "              focusUrlBar: true,"
new = "              focusUrlBar: false,"
if old in content:
    open(f, "w").write(content.replace(old, new, 1))
    print("  patched tabbrowser.js")
else:
    print("  WARNING: tabbrowser pattern not found — check Firefox version")
PYEOF

(cd "$WORK_DIR" && zip -q -r -0 /tmp/_ff_browser_omni.ja . 2>/dev/null)
mv /tmp/_ff_browser_omni.ja "$BROWSER_OMNI"
rm -rf "$WORK_DIR"
echo "     browser/omni.ja replaced"

# ── Restore userChrome.css ───────────────────────────────────────────────────
# Firefox updates 不会动 profile，但顺便写回最新版本防止手误丢失。
PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles/main.default-release"
mkdir -p "$PROFILE_DIR/chrome"
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
echo "[2] userChrome.css restored"

# ── Restore Tridactyl settings ───────────────────────────────────────────────
TRIDACTYL_RC="$HOME/.config/tridactyl/tridactylrc"
mkdir -p "$(dirname "$TRIDACTYL_RC")"
if [ -f "$TRIDACTYL_RC" ]; then
    if grep -q "^set modeindicator" "$TRIDACTYL_RC"; then
        sed -i '' "s|^set modeindicator.*|set modeindicator false|" "$TRIDACTYL_RC"
    else
        echo "set modeindicator false" >> "$TRIDACTYL_RC"
    fi
else
    echo "set modeindicator false" > "$TRIDACTYL_RC"
fi
echo "[3] Tridactyl modeindicator set in $TRIDACTYL_RC"

# ── Clear startup cache ───────────────────────────────────────────────────────
rm -rf "$HOME/Library/Caches/Firefox/Profiles/*/startupCache/"
echo "[4] Startup cache cleared"

echo ""
echo "=== Done. Start Firefox to apply. ==="
