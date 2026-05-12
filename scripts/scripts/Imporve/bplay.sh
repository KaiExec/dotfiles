#!/usr/bin/env bash
# bplay <bilibili URL>
# 依赖: yt-dlp, fzf

set -euo pipefail

URL="${1:-}"
[[ -z "$URL" ]] && { echo "用法: bplay <URL>"; exit 1; }

echo "正在解析列表..." >&2

ENTRIES=""

# Fast path: space/lists URLs — use Bilibili API to get all titles in one call
if [[ "$URL" =~ space\.bilibili\.com/[0-9]+/lists/[0-9]+ ]]; then
    ENTRIES=$(BPLAY_URL="$URL" python3 << 'PYEOF'
import os, re, json, urllib.request

url = os.environ['BPLAY_URL']
m   = re.search(r'space\.bilibili\.com/(\d+)/lists/(\d+)', url)
uid, list_id  = m.group(1), m.group(2)
is_season     = 'type=season' in url

headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Referer':    'https://space.bilibili.com/',
}

archives, page = [], 1
while True:
    if is_season:
        api = (f"https://api.bilibili.com/x/polymer/web-space/seasons_archives_list"
               f"?mid={uid}&season_id={list_id}&page_num={page}&page_size=100")
    else:
        api = (f"https://api.bilibili.com/x/series/archives"
               f"?mid={uid}&series_id={list_id}&pn={page}&ps=100&sort=asc")

    req = urllib.request.Request(api, headers=headers)
    with urllib.request.urlopen(req, timeout=10) as r:
        data = json.loads(r.read())

    if data.get('code') != 0:
        break
    batch = data['data'].get('archives', [])
    if not batch:
        break
    archives.extend(batch)
    total = data['data'].get('page', {}).get('total', len(archives))
    if len(archives) >= total:
        break
    page += 1

for i, a in enumerate(archives, 1):
    bvid  = a.get('bvid', '')
    title = a.get('title', bvid)
    print(f"{i}\t{title}\thttps://www.bilibili.com/video/{bvid}/")
PYEOF
    )
fi

# General path: yt-dlp for all other Bilibili URLs
# Write Python to a tmp file so stdin can carry yt-dlp data (pipe + heredoc conflict)
if [[ -z "$ENTRIES" ]]; then
    YTDLP_OUT=$(yt-dlp --flat-playlist -j "$URL" 2>/dev/null) || true
    if [[ -n "$YTDLP_OUT" ]]; then
        TMPPY=$(mktemp /tmp/bplay_XXXXXX.py)
        trap 'rm -f "$TMPPY"' EXIT
        cat > "$TMPPY" << 'PYEOF'
import json, sys, re
from concurrent.futures import ThreadPoolExecutor
import urllib.request

raw = []
for line in sys.stdin:
    line = line.strip()
    if not line.startswith('{'):
        continue
    d    = json.loads(line)
    idx  = d.get('playlist_index') or '?'
    url  = d.get('url') or d.get('webpage_url') or ''
    bvid = d.get('id') or ''
    if not re.match(r'^BV[A-Za-z0-9]+$', bvid):
        mm = re.search(r'(BV[A-Za-z0-9]+)', url)
        bvid = mm.group(1) if mm else ''
    raw.append((idx, bvid, url))

def fetch_title(entry):
    idx, bvid, url = entry
    if not bvid:
        return idx, url, url
    try:
        req = urllib.request.Request(
            f"https://api.bilibili.com/x/web-interface/view?bvid={bvid}",
            headers={'User-Agent': 'Mozilla/5.0',
                     'Referer': 'https://www.bilibili.com/'}
        )
        with urllib.request.urlopen(req, timeout=8) as r:
            title = json.loads(r.read())['data']['title']
    except Exception:
        title = bvid
    return idx, title, url

with ThreadPoolExecutor(max_workers=10) as ex:
    results = list(ex.map(fetch_title, raw))

results.sort(key=lambda x: int(x[0]) if str(x[0]).isdigit() else 0)
for idx, title, url in results:
    print(f'{idx}\t{title}\t{url}')
PYEOF
        ENTRIES=$(echo "$YTDLP_OUT" | python3 "$TMPPY")
    fi
fi

[[ -z "$ENTRIES" ]] && { echo "列表解析失败，检查 URL 或网络"; exit 1; }

# ── Resume state ───────────────────────────────────────────────────────────────
HISTORY_FILE="${HOME}/.local/share/bplay/history.json"
URL_HASH=$(python3 -c "import hashlib,sys; print(hashlib.md5(sys.argv[1].encode()).hexdigest()[:16])" "$URL")

LAST_IDX=0
if [[ -f "$HISTORY_FILE" ]]; then
    LAST_IDX=$(BPLAY_HASH="$URL_HASH" BPLAY_FILE="$HISTORY_FILE" python3 << 'PYEOF'
import json, os
try:
    print(json.load(open(os.environ['BPLAY_FILE'])).get(os.environ['BPLAY_HASH'], {}).get('last_idx', 0))
except Exception:
    print(0)
PYEOF
    )
fi

COUNT=$(echo "$ENTRIES" | wc -l | tr -d ' ')
RESUME_IDX=$((LAST_IDX + 1))

# Mark the resume entry in the title column (only if within range)
if [[ "$LAST_IDX" -gt 0 && "$RESUME_IDX" -le "$COUNT" ]]; then
    ENTRIES=$(echo "$ENTRIES" | awk -F'\t' -v r="$RESUME_IDX" 'BEGIN{OFS="\t"} $1==r{$2="▶ 继续  "$2} {print}')
fi

echo "共 ${COUNT} 集，正在打开选集界面..." >&2

# Build fzf options; pre-fill query with resume idx so fzf scrolls to it
FZF_OPTS=(
  --multi
  --with-nth=1,2
  --delimiter=$'\t'
  --prompt="选集 (Tab 多选, Ctrl-A 全选, Enter 播放): "
  --height=60%
  --layout=reverse
  --bind='ctrl-a:select-all,ctrl-d:deselect-all,j:down,k:up'
)
if [[ "$LAST_IDX" -gt 0 && "$RESUME_IDX" -le "$COUNT" ]]; then
    FZF_OPTS+=(--header "上次看到第 ${LAST_IDX} 集，从第 ${RESUME_IDX} 集继续")
    FZF_OPTS+=(--query "${RESUME_IDX}")
fi

SELECTED=$(echo "$ENTRIES" | fzf "${FZF_OPTS[@]}") || true
[[ -z "$SELECTED" ]] && exit 0

# Save the last selected idx as the new resume point
SAVE_IDX=$(echo "$SELECTED" | tail -1 | cut -f1)
if [[ "$SAVE_IDX" =~ ^[0-9]+$ ]]; then
    BPLAY_HASH="$URL_HASH" BPLAY_IDX="$SAVE_IDX" BPLAY_URL="$URL" BPLAY_FILE="$HISTORY_FILE" python3 << 'PYEOF'
import json, os
f, h = os.environ['BPLAY_FILE'], os.environ['BPLAY_HASH']
os.makedirs(os.path.dirname(f), exist_ok=True)
d = {}
if os.path.exists(f):
    try: d = json.load(open(f))
    except Exception: pass
d[h] = {'last_idx': int(os.environ['BPLAY_IDX']), 'url': os.environ['BPLAY_URL']}
json.dump(d, open(f, 'w'), ensure_ascii=False, indent=2)
PYEOF
fi

URLS=()
while IFS=$'\t' read -r idx title url; do
  echo "▶ 加入队列 第 ${idx} 集：${title}" >&2
  URLS+=("$url")
done <<< "$SELECTED"

mpv \
  --ytdl-format="bestvideo+bestaudio/best" \
  --ytdl-raw-options="cookies-from-browser=safari" \
  "${URLS[@]}"
