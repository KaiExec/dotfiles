return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		config = function()
			require("catppuccin").setup({
				term_colors = true,
				transparent_background = false,
				color_overrides = {
					all = {
						base = "#000000",
						mantle = "#000000",
						crust = "#000000",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
