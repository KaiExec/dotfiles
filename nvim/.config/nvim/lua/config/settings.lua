local opt = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.number = true
opt.relativenumber = true
opt.clipboard:append("unnamedplus")
opt.termguicolors = true

-- Tab and Indentation

opt.shiftwidth = 4 -- Indentation
opt.tabstop = 4 -- Tab looks like
opt.expandtab = true -- Convert to space TvT
-- opt.smarttab = true -- Distinguish tab and indentation

opt.scrolloff = 7

opt.list = true
local space = "·"
opt.listchars:append({
	tab = "│─",
	multispace = space,
	lead = space,
	trail = space,
	nbsp = space,
})
