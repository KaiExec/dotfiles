local M = {}

function M:entry()
	local hovered = cx.active.current.hovered
	if not hovered then
		ya.notify({ title = "Wallpaper", content = "No file selected", timeout = 2, level = "warn" })
		return
	end

	local path = tostring(hovered.url)
	local script = string.format(
		'tell application "System Events" to tell every desktop to set picture to "%s"',
		path:gsub('"', '\\"')
	)

	local _, err = Command("osascript"):args({ "-e", script }):output()
	if err then
		ya.notify({ title = "Wallpaper", content = tostring(err), timeout = 3, level = "error" })
		return
	end

	ya.notify({ title = "Wallpaper", content = "→ " .. (path:match("([^/]+)$") or path), timeout = 2 })
end

return M
