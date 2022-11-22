vim.g.mapleader = " "

local km = vim.keymap
-- Telescope
km.set("n", "ff", ":Telescope find_files hidden=true theme=ivy<CR>")
km.set("n", "gf", ":Telescope live_grep theme=ivy<CR>") 
km.set("n", "bf", ":Telescope file_browser theme=ivy<CR>", { noremap = true })
km.set("n", "sc", ":Telescope colorscheme theme=ivy<CR>")
km.set("n", "fs", ":Telescope grep_string theme=ivy<CR>")
km.set("n", "fb", ":Telescope buffers theme=ivy<CR>")
km.set("n", "fh", ":Telescope help_tags theme=ivy<CR>")
km.set("n", "rf", ":Telescope oldfiles theme=ivy<CR>")

-- Windows
km.set("n", "hs", ":sp<CR>") 
km.set("n", "vs", ":vs<CR>")
km.set("n", "cl", ":q!<CR>")

-- Nvim Tree
km.set("n", "tt", ":NvimTreeToggle<CR>")
km.set("n", "tf", ":NvimTreeFocus<CR>")

-- Which Key
km.set("n", "wk", ":WhichKey<CR>")

-- Do not put deleted char into register
km.set("n", "x", '"_x')

-- Barbar
-- Move to previous/next
km.set("n", ",", ":BufferPrevious<CR>", { noremap = true })
km.set("n", ".", ":BufferNext<CR>", { noremap = true })

-- Move blocks of text around
-- visual mode
-- :move visually selected lines under second previous line
-- reselect previous visual selection
-- reindent
-- reselect again.
km.set("v", "<A-k>", ":move-2<CR>gv=gv")
km.set("v", "<A-j>", ":move'>+<CR>gv=gv")
