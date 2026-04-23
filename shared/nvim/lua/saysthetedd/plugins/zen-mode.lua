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
			wrap = true,
		},
	},
})

vim.keymap.set("n", "zm", ":ZenMode<CR>", { silent = true })
