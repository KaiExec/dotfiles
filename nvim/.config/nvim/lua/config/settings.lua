local opt = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


opt.relativenumber = true
opt.clipboard:append("unnamedplus")

-- Tab and Indentation

opt.shiftwidth = 4 -- Indentation
opt.tabstop = 4 -- Tab looks like
opt.expandtab = true -- Convert to space TvT
-- opt.smarttab = true -- Distinguish tab and indentation

opt.scrolloff = 7
