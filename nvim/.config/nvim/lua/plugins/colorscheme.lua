return {
	"bluz71/vim-moonfly-colors",
	main = "moonfly",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme moonfly]])
	end,
}
