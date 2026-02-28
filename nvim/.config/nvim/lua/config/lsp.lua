local opt = vim.lsp
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lspConfig", { clear = true }),
	callback = function(event)
		local client = opt.get_client_by_id(event.data.client_id)
		local function diagnosticOn()
			vim.diagnostic.config({
				underline = true,
				virtual_text = true,
				signs = {
					active = true,
					text = {
						[vim.diagnostic.severity.ERROR] = "󱎶",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰊠",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				update_in_insert = true,
			})
		end
		diagnosticOn()
		-- Show Hover Information
		Map("n", "M", function()
			opt.buf.hover({ border = "rounded" })
		end, { buffer = event.buf, desc = "LSP: Show Hover Info" })

		-- Jump to Definition
		Map("n", "gd", opt.buf.definition, { buffer = event.buf, desc = "LSP: Goto Definition" })
		Map("n", "gD", opt.buf.declaration, { buffer = event.buf, desc = "LSP: Goto Declaration" })

		-- Rename
		Map("n", "<leader>rn", opt.buf.rename, { buffer = event.buf, desc = "LSP: Rename" })

		-- Diagnostics
		local isShown = true
		Map("n", "<leader>td", function()
			if isShown then
				vim.diagnostic.config({
					underline = false,
					virtual_text = false,
					signs = false,
					update_in_insert = false,
				})
			else
				diagnosticOn()
			end
			isShown = not isShown
		end, { buffer = event.buf, desc = "LSP: Goto Declaration" })
		Map("n", "<leader>ed", vim.diagnostic.open_float, { desc = "Floating Diagnostics" })

		-- Inlay Hint
		if client:supports_method(opt.protocol.Methods.textDocument_inlayHint) then
			opt.inlay_hint.enable(true, { bufnr = event.buf })
		end
	end,
})

-- List
opt.enable("lua_ls")
opt.enable("pyright")
opt.enable("gopls")
opt.enable("vtsls")
opt.enable("fish_lsp")
opt.enable("rnix")
opt.enable("clangd")
opt.enable("rust_analyzer")
opt.enable("cssls")
opt.enable("vue_ls")
