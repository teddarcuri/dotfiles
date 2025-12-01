-- https://www.youtube.com/watch?v=vdn_pKJUda8&t=143s&ab_channel=JoseanMartinez
local opt = vim.opt
-- line numbers
opt.relativenumber = true
opt.number = true
-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
-- line wrap
opt.wrap = false
-- search
-- opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true -- While typing the search pattern the current match will be shown
-- cursor line
opt.cursorline = true
-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
-- treesitter
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

-- backspace
-- opt.backspace = "indent,eol,start"
-- clipboard
-- opt.clipboard:append("unnamedplus")
-- split windows
-- opt.splitright = true
-- opt.splitbelow = true

-- Highlight Yanked Text Briefly
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    callback = function()
        vim.highlight.on_yank({timeout = 500})
    end,
})
