require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  },
  indent = { enable = true },
  autotag =  {enable = true },

  ensure_installed = {
    "rust", 
    "lua", 
    "typescript",
    "javascript", 
    "svelte",
    "json",
    "gitignore",
    "html",
    "css",
    "tsx",
    "bash",
    "vim"
  },
  auto_install = true
}
