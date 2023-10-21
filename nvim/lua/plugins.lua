vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Toml syntax support
  use 'cespare/vim-toml'

  -- Kotlin syntax support
  use 'udalov/kotlin-vim'

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  -- Colors
  use 'tomasiser/vim-code-dark'

  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
  }

  use 'nvim-treesitter/nvim-treesitter-context'

  -- Completion
  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      requires = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},

          -- LSP Management
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'saadparwaiz1/cmp_luasnip'},
      }
  }

  -- Snippets
  use {
    'L3MON4D3/LuaSnip',
    tag = 'v2.*',
    run = 'make install_jsregexp',

    requires = {
      'rafamadriz/friendly-snippets'
    }
  }

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'leoluz/nvim-dap-go'
  use 'mfussenegger/nvim-dap-python'

  -- Float Term
  use 'voldikss/vim-floaterm'

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- File tree
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  -- Git stuff
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim'
    }
  }

  -- Git icons
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Dev icons
  use 'nvim-tree/nvim-web-devicons'

  -- LSP initialization status
  use {
    'j-hui/fidget.nvim',
    tag = 'legacy',
  }

  -- LSP context info
  use {
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
  }

  -- Buffer info
  use {
    'romgrk/barbar.nvim',
    requires = {
      'nvim-tree/nvim-web-devicons',
      'lewis6991/gitsigns.nvim',
    }
  }

  -- Build Tasks
  use {
    'stevearc/overseer.nvim',
    config = function() require('overseer').setup() end
  }

  -- Markdown previewer
  use {
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast'
  }


end)
