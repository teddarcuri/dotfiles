local status, zen = pcall(require, "zen-mode")
if not status then
	return
end

zen.setup({
	window = {
		width = 100,
		options = {
			number = false,
			relativenumber = false,
			wrap = true,
			linebreak = true,
			breakindent = true,
		},
	},
	on_open = function(win)
		vim.cmd("setlocal wrap linebreak breakindent")
	end,
	on_close = function()
		vim.cmd("setlocal nowrap")
	end,
})

vim.keymap.set("n", "zm", ":ZenMode<CR>", { silent = true })
