# Firefox Post-Update

## 何时使用
每次 Firefox 版本更新后运行。适用场景：
- Firefox 自动更新完成后
- 手动下载新版本覆盖安装后

更新会替换整个 app bundle，其中包括 `browser/omni.ja`，导致之前的 patch 失效，需要重新打。Profile 数据（书签、密码、扩展、user.js、userChrome.css）不受影响，无需重新配置。

## 执行方式
```bash
bash ~/Scripts/PUS/firefox/firefox.sh
```
Firefox 必须处于关闭状态。

## 会做什么

1. **Re-patch browser/omni.ja** — 重新修改 Firefox 内部 JS，禁止新 Tab 打开时自动聚焦地址栏（修改 `URILoadingHelper.sys.mjs` 和 `tabbrowser.js` 中的 `focusUrlBar` 逻辑）
2. **恢复 userChrome.css** — 写回最新版本的 chrome 样式，包含：工具栏自动隐藏、Cmd+L 瞬间展开修复、垂直 tab 序号徽标（Cmd+1–9）
3. **恢复 Tridactyl 配置** `~/.config/tridactyl/tridactylrc` — 写入 `set modeindicator false`（隐藏右下角 mode 指示）
4. **清除 Startup Cache** — 确保新 patch 立即生效

## 注意
- 如果 Firefox 大版本更新后脚本输出 WARNING（pattern not found），说明源码结构有变化，需要重新定位 patch 位置并更新脚本
- `browser/omni.ja` 的 backup 保存在原路径加 `.backup` 后缀
