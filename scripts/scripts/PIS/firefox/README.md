# Firefox Post-Install Setup

## 何时使用
全新安装 Firefox 之后运行一次。适用场景：
- 新 Mac 上首次安装 Firefox
- 卸载重装 Firefox
- 手动创建新 Profile 后

## 执行方式
```bash
bash ~/Scripts/PIS/firefox/firefox.sh
```
Firefox 必须处于关闭状态。

## 会做什么

1. **创建 Profile 目录** `~/Library/Application Support/Firefox/Profiles/main.default-release`
2. **写入 profiles.ini** — 将上述 Profile 设为默认，禁用启动时的 Profile 选择器
3. **写入 user.js** — 设置以下偏好：
   - 启动页显示主页（而非恢复上次 Session）
   - 主页设为 `http://127.0.0.1:8080/startpage.html`
   - 启用 userChrome 自定义样式
4. **写入 userChrome.css** — 工具栏自动隐藏（鼠标悬停或 Cmd+L 时展开）、Cmd+L 瞬间展开修复、垂直 tab 序号徽标（Cmd+1–9）
5. **迁移扩展文件**（检测到旧 profile 时自动执行）— 复制 `xulstore.json`（工具栏图标位置）、`extension-settings.json`（扩展权限）、`extension-store*` 系列目录（扩展存储）
6. **Patch browser/omni.ja** — 修改 Firefox 内部 JS，禁止新 Tab 打开时自动聚焦地址栏
7. **写入 Tridactyl 配置** `~/.config/tridactyl/tridactylrc` — 将 Tridactyl 接管的 newtab 设为 `http://127.0.0.1:8080/startpage.html`；隐藏右下角 mode 指示（`set modeindicator false`）
8. **清除 Startup Cache** — 确保所有改动立即生效

## 注意
- Tridactyl newtab 生效需要 native messenger 已安装：在 Firefox 中执行 `:installnative`
- `browser/omni.ja` 的 backup 保存在原路径加 `.backup` 后缀
