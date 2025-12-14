function Map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Move
Map({ "n", "v" }, "J", "5j")
Map({ "n", "v" }, "K", "5k")
Map({ "n", "v", "o" }, "H", "^")
Map({ "n", "v", "o" }, "L", "$")
