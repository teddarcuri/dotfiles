local status, zen = pcall(require, "zen-mode")
if not status then
	return
end

zen.setup({
	window = {
		width = 0.75,
		options = {
			number = false,
			relativenumber = false,
		},
	},
	on_open = function(win)
		vim.wo[win].wrap = true
		vim.wo[win].linebreak = true
	end,
	on_close = function()
		vim.wo.wrap = false
	end,
})

vim.keymap.set("n", "zm", ":ZenMode<CR>", { silent = true })
