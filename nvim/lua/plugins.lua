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
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'
  use 'williamboman/nvim-lsp-installer'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'leoluz/nvim-dap-go'
  use 'mfussenegger/nvim-dap-python'

  -- Float Term
  use 'voldikss/vim-floaterm'
end)
