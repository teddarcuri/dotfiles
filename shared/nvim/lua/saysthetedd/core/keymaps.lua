vim.g.mapleader = " "

local km = vim.keymap
-- Telescope
km.set("n", "ff", ":Telescope find_files hidden=true theme=dropdown<CR>")
km.set("n", "gf", ":Telescope live_grep theme=dropdown<CR>")
km.set("n", "bf", ":Telescope file_browser theme=dropdown<CR>", {
    noremap = true
})
km.set("n", "sc", ":Telescope colorscheme theme=dropdown<CR>")
km.set("n", "fs", ":Telescope grep_string theme=dropdown<CR>")
km.set("n", "fb", ":Telescope buffers theme=dropdown<CR>")
km.set("n", "fh", ":Telescope help_tags theme=dropdown<CR>")
km.set("n", "rf", ":Telescope oldfiles theme=dropdown<CR>")

-- Trouble
km.set("n", "te", ":TroubleToggle<CR>")

-- Windows
km.set("n", "hs", ":sp<CR>")
km.set("n", "vs", ":vs<CR>")
km.set("n", "cl", ":q!<CR>")
km.set("n", "sm", ":MaximizerToggle<CR>") -- expand/shrink current window

-- Which Key
km.set("n", "wk", ":WhichKey<CR>")

-- Do not put deleted char into register
km.set("n", "x", '"_x')

-- Move blocks of text around
-- visual mode
-- :move visually selected lines under second previous line
-- reselect previous visual selection
-- reindent
-- reselect again.
km.set("v", "<A-k>", ":move-2<CR>gv=gv")
km.set("v", "<A-j>", ":move'>+<CR>gv=gv")

-- Terminal
km.set("n", "ts", ":ToggleTerm<CR>")

-- Copy to system clipboard
-- 2do make this work. cuz it ain't 
km.set("n", "cts", '"+y')
