return {
	{
		"oskarnurm/koda.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("koda").setup({
				auto = true,
				transparent = true,
				styles = {
					functions = { bold = true, italic = true },
					keywords = {},
					comments = { italic = true },
					strings = {},
					constants = {}, -- includes numbers, booleans
				},
				on_highlights = function(hl, c)
					hl.Todo = { fg = c.info, bold = true }
					hl.Comment = { fg = "#C2FF69", italic = true }
					hl.DiagnosticUnnecessary = { fg = c.comment, italic = true }
				end,
			})
			vim.cmd("colorscheme koda")
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
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {},
	},
}
