return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  
  -- themez
  use 'savq/melange'
  use 'kvrohit/mellow.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'sam4llis/nvim-tundra'
  use 'sainnhe/everforest'
  use 'sainnhe/gruvbox-material'
  use 'sainnhe/sonokai'

  -- telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                          , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  } 
  use { "nvim-telescope/telescope-file-browser.nvim" } -- file tree navigator
  use { "nvim-telescope/telescope-fzf-native.nvim", run ='make' }

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  
  -- nvim tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  
  -- Svelte Support
  use 'othree/html5.vim'
  use 'pangloss/vim-javascript'
  use { 'evanleck/vim-svelte', branch = 'main'}
  
  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
  }
  
  -- Commenting
  use { 'numToStr/Comment.nvim' }
  
  -- Autopair tags + brackets
  use { 'windwp/nvim-autopairs' }
  use { 'windwp/nvim-ts-autotag', after="nvim-treesitter" } -- autoclose/pair html tags
  
  -- Buffer management 
  use { 'romgrk/barbar.nvim' }
  use {
    "utilyre/barbecue.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "smiteshp/nvim-navic",
    },
    config = function()
      require("barbecue").setup()
    end,
  }
  
  -- Tmux + Window navigation
  use("christoomey/vim-tmux-navigator")
  
  -- Terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = '*', 
  }

  -- fin.
  if packer_bootstrap then
    require('packer').sync()
  end
end)

