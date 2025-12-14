vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lspConfig", { clear = true }),
	callback = function(event)
		local opt = vim.lsp
		local client = opt.get_client_by_id(event.data.client_id)

		-- Show Hover Information
		Map("n", "M", opt.buf.hover, { buffer = event.buf, desc = "LSP: Show Hover Info" })

		-- Jump to Definition
		Map("n", "gd", opt.buf.definition, { buffer = event.buf, desc = "LSP: Goto Definition" })
		Map("n", "gD", opt.buf.declaration, { buffer = event.buf, desc = "LSP: Goto Declaration" })

		-- Rename
		Map("n", "<leader>rn", opt.buf.rename, { buffer = event.buf, desc = "LSP: Rename" })

		-- Diagnostics
		Map(
			"n",
			"<leader>td",
			(function()
				local status = 1 -- 1 show, 0 hide
				return function()
					if status == 1 then
						vim.diagnostic.config({
							underline = true,
							virtual_text = true,
							signs = true,
							update_in_insert = true,
						})
						status = 0
					else
						vim.diagnostic.config({
							underline = false,
							virtual_text = false,
							signs = false,
							update_in_insert = false,
						})
						status = 1
					end
				end
			end)(),
			{ buffer = event.buf, desc = "LSP: Goto Declaration" }
		)

		-- Inlay Hint
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
		end
	end,
})

-- List
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("gopls")
vim.lsp.enable("vtsls")
vim.lsp.enable("zk")
