-- disable netrw at the very start of your init.lua (strongly advised)
-- https://github.com/nvim-tree/nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("saysthetedd.plugins-setup")
require("saysthetedd.core.options")
require("saysthetedd.core.keymaps")
require("saysthetedd.core.colorscheme")
require("saysthetedd.plugins.lualine")
require("saysthetedd.plugins.telescope")
require("saysthetedd.plugins.treesitter")
require("saysthetedd.plugins.barbar")
require("saysthetedd.plugins.autopairs")
require("saysthetedd.plugins.comment")
require("saysthetedd.plugins.nvim-tree")
require("saysthetedd.plugins.toggleterm")
require("saysthetedd.plugins.cmp")
