vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer
  use "wbthomason/packer.nvim"

  -- Toml syntax support
  use "cespare/vim-toml"

  -- Kotlin syntax support
  use "udalov/kotlin-vim"

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },

    config = function() require("plugin-configs/telescope") end
  }

  -- Colors
  use {
    "tomasiser/vim-code-dark",
    config = function() require("plugin-configs/colors") end
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-context"
    },
    run = ":TSUpdate",

    config = function() require("plugin-configs/treesitter") end
  }

  use "nvim-treesitter/nvim-treesitter-context"

  -- Completion
  use {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    requires = {
      -- LSP Support
      "neovim/nvim-lspconfig",

      -- LSP Management
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Autocompletion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",

      -- Icons
      "onsails/lspkind.nvim",

      -- Snippets
      "saadparwaiz1/cmp_luasnip",

      -- Inlay hints
      "lvimuser/lsp-inlayhints.nvim",

      -- Json schemas
      "b0o/schemastore.nvim"
    },

    config = function() require("plugin-configs/lsp") end
  }

  use {
    "L3MON4D3/LuaSnip",
    tag = "v2.*",
    run = "make install_jsregexp",

    requires = {
      "rafamadriz/friendly-snippets"
    }
  }

  -- Debugging
  use {
    'mfussenegger/nvim-dap',
    requires = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },

    config = function() require("plugin-configs/dap") end
  }

  -- Terminal
  use {
    "akinsho/toggleterm.nvim",
    config = function() require("plugin-configs.toggleterm") end
  }

  -- Status line
  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function() require("plugin-configs/lualine") end
  }


  -- File tree
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    config = function() require("plugin-configs/neotree") end
  }

  use {
    "s1n7ax/nvim-window-picker",
    config = function() require("plugin-configs.window-picker") end
  }

  -- Git stuff
  use {
    'TimUntersberger/neogit',
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },

    config = function() require("plugin-configs/neogit") end
  }

  -- Git icons
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require("plugin-configs.gitsigns") end
  }

  -- LSP initialization status
  --use {
  --  'j-hui/fidget.nvim',
  --  config = function() require("plugin-configs.fidget") end,
  --}

  -- LSP context info
  use {
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    after = "nvim-web-devicons",
    config = function() require("barbecue").setup() end,
  }

  -- Buffer info
  use {
    'romgrk/barbar.nvim',
    requires = {
      'nvim-tree/nvim-web-devicons',
      'lewis6991/gitsigns.nvim',
    },
    config = function() require("plugin-configs.barbar") end
  }

  -- Build Tasks
  use {
    'stevearc/overseer.nvim',
    config = function() require("plugin-configs.overseer") end,
  }

  -- Markdown previewer
  use {
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
    config = function() require("plugin-configs/peek") end,
  }


end)
