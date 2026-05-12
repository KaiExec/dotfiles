-- Ghostty palette: bg=#0b1618 fg=#c4d4d6 cursor=#3dbdbd
-- red=#bf7878 green=#4aaf98 yellow=#c8a878 blue=#4880b0 purple=#b07898 cyan=#3dbdbd
return {
	{
		"oskarnurm/koda.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("koda").setup({
				auto = false,
				transparent = true,
				styles = {
					functions = { bold = true, italic = true },
					keywords = { bold = true },
					comments = { italic = true },
					strings = {},
					constants = {},
				},
				on_highlights = function(hl, _)
					-- syntax: aligned with ghostty palette for coherence across panes
					hl.Keyword      = { fg = "#5898cc", bold = true }
					hl.Statement    = { fg = "#5898cc", bold = true }
					hl.Conditional  = { fg = "#5898cc", bold = true }
					hl.Repeat       = { fg = "#5898cc", bold = true }
					hl.Function     = { fg = "#58c8b0", bold = true, italic = true }
					hl["@function"] = { fg = "#58c8b0", bold = true, italic = true }
					hl.String       = { fg = "#c8a878" }
					hl.Number       = { fg = "#3dbdbd" }
					hl.Boolean      = { fg = "#3dbdbd" }
					hl.Constant     = { fg = "#3dbdbd" }
					hl.Type         = { fg = "#4aaf98" }
					hl.Special      = { fg = "#b07898" }
					hl.Comment      = { fg = "#3a5a60", italic = true }   -- deep muted teal: quiet, not loud
					hl.Identifier   = { fg = "#c4d4d6" }
					hl.Operator     = { fg = "#94b4b4" }

					-- diagnostics
					hl.DiagnosticError       = { fg = "#bf7878" }
					hl.DiagnosticWarn        = { fg = "#c8a878" }
					hl.DiagnosticInfo        = { fg = "#4880b0" }
					hl.DiagnosticHint        = { fg = "#3dbdbd" }
					hl.DiagnosticUnnecessary = { fg = "#2e4a50", italic = true }

					-- UI chrome: barely visible, recede into the background
					hl.LineNr       = { fg = "#1c3035" }
					hl.CursorLineNr = { fg = "#3dbdbd", bold = true }
					hl.CursorLine   = { bg = "#0d1e22" }
					hl.Visual       = { bg = "#1a3030" }
					hl.Search       = { fg = "#0b1618", bg = "#3dbdbd" }
					hl.IncSearch    = { fg = "#0b1618", bg = "#58c8b0", bold = true }
					hl.MatchParen   = { fg = "#3dbdbd", bold = true, underline = true }
					hl.StatusLine   = { fg = "#94b4b4", bg = "NONE" }
					hl.StatusLineNC = { fg = "#1c3035", bg = "NONE" }
					hl.WinSeparator = { fg = "#1c3035" }
					hl.FloatBorder  = { fg = "#1c3035" }
					hl.NormalFloat  = { bg = "NONE" }
					hl.Pmenu        = { fg = "#94b4b4", bg = "#0d1e22" }
					hl.PmenuSel     = { fg = "#c4d4d6", bg = "#1a3030" }
					hl.PmenuSbar    = { bg = "#0d1e22" }
					hl.PmenuThumb   = { bg = "#1c3035" }
					hl.Todo         = { fg = "#c8a878", bold = true }
					hl.Title        = { fg = "#3dbdbd", bold = true }
				end,
			})
			vim.cmd("colorscheme koda")
		end,
	},
}
