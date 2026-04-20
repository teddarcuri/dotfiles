local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local km = vim.keymap

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	km.set("n", "gF", "<cmd>Lspsaga lsp_finder<CR>", opts)
	km.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	km.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
	km.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	km.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	km.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	km.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	km.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	km.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	km.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	km.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	km.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)

	if client.name == "ts_ls" then
		km.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
		km.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
		km.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
	end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("svelte", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("tailwindcss", {
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

vim.lsp.enable({ "html", "ts_ls", "cssls", "svelte", "tailwindcss", "lua_ls" })
