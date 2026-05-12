# Post-Update Scripts

Spotify 每次更新会抹掉 Spicetify 的注入，运行对应脚本还原。

## 目录结构

```
PUS/
├── README.md          ← 本文件
└── Spotify/
    ├── patch-lyrics-plus.sh         重新注入 Lyrics Plus（Netease URL 替换 + 楷体字体）
    ├── patch-lyrics-to-web.sh       重新注入 Lyrics Wall 扩展（见下方详细文档）
    ├── com.user.ncm-proxy.plist     LaunchAgent：NCM 代理服务器
    ├── com.user.lyrics-wall.plist   LaunchAgent：Lyrics Wall SSE 服务器
    └── ncm-proxy.js                 NCM 代理实现
```

---

## Spotify 更新后操作顺序

```bash
# 1. 先跑 Lyrics Wall（lyrics-to-web 是普通 spicetify 扩展，apply 一次即可）
~/scripts/PUS/Spotify/patch-lyrics-to-web.sh

# 2. 再跑 Lyrics Plus 补丁（在 apply 之后修改 spicetify 已生成的 JS 文件）
~/scripts/PUS/Spotify/patch-lyrics-plus.sh

# 3. 重启 Spotify
```

顺序不能反：`patch-lyrics-plus.sh` 直接改 xpui 目录里的文件，`spicetify apply` 会覆盖它，所以必须最后跑。

---

## Lyrics Wall

### 概述

Spicetify 扩展 + 本地 Python SSE 服务器。扩展从 Spotify 内部 API 拉取歌词并推送到服务器，你的网页通过 SSE 订阅实时歌词和播放进度。

```
Spotify/Spicetify
  └─ lyrics-to-web.js
       ├─ POST /lyrics     换歌时推送（歌名、歌手、歌词行数组）
       └─ POST /progress   每 500ms 推送播放进度

Python Server  localhost:7432
  ├─ GET  /          内置测试页
  └─ GET  /events    SSE 流 ← 你的网页订阅这里
```

### 相关文件

| 文件 | 说明 |
|---|---|
| `~/.config/spicetify/Extensions/lyrics-to-web.js` | Spicetify 扩展源文件，`spicetify apply` 从这里读取 |
| `~/lyrics-wall/server.py` | SSE 服务器，LaunchAgent 管理 |
| `~/lyrics-wall/index.html` | 内置测试页，可直接浏览器打开验证 |
| `~/Library/LaunchAgents/com.user.lyrics-wall.plist` | 已加载的 LaunchAgent |

### SSE 接口

在你的网页中连接：

```js
const es = new EventSource('http://localhost:7432/events');

es.onmessage = (e) => {
  const d = JSON.parse(e.data);

  if (d.type === 'state' || d.type === 'lyrics') {
    // 初始连接 / 换歌
    // d.title      {string}  歌名
    // d.artist     {string}  歌手
    // d.positionMs {number}  当前进度（换歌时为 0）
    // d.lyrics     {Array}   歌词行，见下方格式
  }

  if (d.type === 'progress') {
    // 每 500ms 一次
    // d.positionMs {number}  当前播放毫秒数
  }
};

es.onerror = () => { /* 服务器未启动或重启中，EventSource 会自动重连 */ };
```

**歌词行格式：**

```js
// d.lyrics 数组，每项：
{ startTimeMs: "12340", words: "Hello world" }

// 找当前高亮行：
function currentLineIndex(lyrics, posMs) {
  let idx = -1;
  for (let i = 0; i < lyrics.length; i++) {
    if (parseInt(lyrics[i].startTimeMs, 10) <= posMs) idx = i;
    else break;
  }
  return idx; // -1 表示歌词尚未开始
}
```

**特殊 words 值：**

| 值 | 含义 |
|---|---|
| `"♪"` | 间奏（纯音乐段落） |
| `""` | 空行 |

### 注意事项

**1. 歌词来源依赖 Spotify 内部 API**

歌词通过 `spclient.wg.spotify.com/color-lyrics/v2/track/{id}` 获取，这是 Spotify 官方歌词接口（同 lyrics-plus 使用的端点）。该 API 无公开文档，若 Spotify 更改接口路径，`lyrics-to-web.js` 需同步更新。

**2. 无歌词的情况**

部分曲目 Spotify 没有授权歌词（常见于非主流曲库、本地文件）。此时 `d.lyrics` 为空数组 `[]`，网页应做相应处理。

**3. 服务器未运行**

扩展发 POST 失败时静默忽略，不会影响 Spotify 正常播放。服务器状态：

```bash
launchctl list | grep lyrics-wall   # 查看是否运行（第三列为 PID）
tail -f ~/Library/Logs/lyrics-wall.log   # 实时日志
```

手动重启：

```bash
launchctl unload ~/Library/LaunchAgents/com.user.lyrics-wall.plist
launchctl load   ~/Library/LaunchAgents/com.user.lyrics-wall.plist
```

**4. Spotify 更新频率**

Spotify 通常每 1–2 周自动更新一次。更新后 Spicetify 注入失效，Spotify 界面会显示"Spicetify 未应用"提示。跑一次 PUS 脚本（顺序见上）即可恢复，LaunchAgent 和歌词服务器不受影响。

**5. 跨域（CORS）**

服务器所有端点均设置 `Access-Control-Allow-Origin: *`，网页从任意本地端口访问均不受限制。
