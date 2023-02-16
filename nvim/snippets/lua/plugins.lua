vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Markdown preview
  use {
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install',
  }

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

  -- Nerdtree
  use 'preservim/nerdtree'

  -- Format on save
  use 'mhartington/formatter.nvim'

  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
  }

  use 'nvim-treesitter/nvim-treesitter-context'

  -- Completion
  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      requires = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},             -- Required
          {'williamboman/mason.nvim'},           -- Optional
          {'williamboman/mason-lspconfig.nvim'}, -- Optional

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},         -- Required
          {'hrsh7th/cmp-nvim-lsp'},     -- Required
          {'hrsh7th/cmp-buffer'},       -- Optional
          {'hrsh7th/cmp-path'},         -- Optional
          {'saadparwaiz1/cmp_luasnip'}, -- Optional
          {'hrsh7th/cmp-nvim-lua'},     -- Optional

          -- Snippets
          {'L3MON4D3/LuaSnip'},             -- Required
          {'rafamadriz/friendly-snippets'}, -- Optional
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

  -- HCL
  use 'jvirtanen/vim-hcl'
end)
