-- Set the terminal shell
if vim.fn.has('win32') == 1 then
  vim.g.floaterm_shell = 'powershell.exe'
else
  vim.g.floaterm_shell = 'zsh'
end

-- Set floating terminal to be a vsplit
vim.g.floaterm_wintype = 'vsplit'

-- Setup telescope
require('telescope').setup{
  defaults = {
    layout_strategy = "vertical",
    theme = "dropdown",
  },

  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
        },
      }
    }
  },
}

-- Add more specific filetype detections
local function yaml_ftdetect(path, bufnr)
  if vim.fn.glob(vim.fn.getcwd() .. "/**/ansible.cfg") ~= "" then
    return "yaml.ansible"
  end
  return "yaml"
end

vim.filetype.add({
  extension = {
    yaml = yaml_ftdetect,
    yml = yaml_ftdetect,
  }
})

-- NeoGit settings
require('neogit').setup{
  kind = "auto",
  integrations = {
    telescope = true,
    diffview = true
  }
}

-- GitSigns settings
require('gitsigns').setup{
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
  }
}

-- Neotree settings
 require("neo-tree").setup({
   default_component_configs = {
     git_status = {
       symbols = {
         untracked = "U",
         ignored = "I",
         unstaged = "M",
         staged = "S",
         conflict = "C"
       }
     }
   },

   source_selector = {
     winbar = true,

     sources = {
       { source = 'filesystem' },
       { source = 'git_status' },
     }
   }
 })

-- Dev icons
require('nvim-web-devicons').setup()

-- Setup LSP
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Command keybinds for nvim lsp such as documentation and goto implementation
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)

  vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
  keymap('n', '<leader>r', ':Telescope lsp_references<CR>', { silent = true })
  vim.keymap.set('n', 'ge', function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set('n', 'gE', function() vim.diagnostic.goto_prev() end, opts)
  keymap('n', '<leader>e', ':Telescope diagnostics<CR>', { silent = true })
  vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, opts)

  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.format_on_save({
  format_opts = {
    async = true,
    timeout_ms = 10000,
  },

  servers = {
    ['rust_analyzer'] = {'rust'},
    ['gopls'] = {'go'},
    ['clangd'] = {'c', 'cpp'},
    ['terraformls'] = {'terraform'},
  }
})

require('mason').setup({}) -- Mason for handling language servers

require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer',
    'gopls',
    'clangd',
  },

  handlers = {
    lsp_zero.default_setup,

    rust_analyzer = function()
      require('lspconfig').rust_analyzer.setup({
        settings = {
          checkOnSave = {
            command = "clippy"
          },

          cargo = {
            features = "all"
          }
        }
      })
    end,

    clangd = function ()
      require('lspconfig').clangd.setup({
        settings = {
          command = {
            'clangd',
            '-clang-tidy',
            '-clang-tidy-checks=-*,clang-analyzer-*,modernize-*,readability-*',
          }
        }
      })
    end
  },
})


local cmp = require('cmp') -- Completion behavior
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- Snippets load
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = nil,
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})


vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

-- Setup LSP status display
require('fidget').setup{}

-- Setup status line
require('lualine').setup{
  options = {
    theme = 'nord'
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },

  tabline = {}
}

-- Setup up DAP debugger
local dapui = require('dapui')
local dap = require('dap')
require('dap-go').setup()
require('dap-python').setup("/usr/bin/python")
require("nvim-dap-virtual-text").setup()
require('telescope').load_extension('dap')

-- Debug adapters
dap.adapters.lldb = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
}

-- Language configurations for DAP
dap.configurations.c = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        args = {},
        runInTerminal = false,
    },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

dap.configurations.go = {
    {
        name = "Debug",
        type = "go",
        request = "launch",
        program = "${file}",
    },
}

-- Debug UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup()

-- Treesitter
require'nvim-treesitter.configs'.setup{
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}

require'treesitter-context'.setup{}

-- Buffer info
require('bufferline').setup()

-- Build task runner
require('overseer').setup()

-- Markdown previewer
require('peek').setup({
  auto_load = false,         -- whether to automatically load preview when
                            -- entering another markdown buffer
  close_on_bdelete = true,  -- close preview window on buffer delete

  syntax = true,            -- enable syntax highlighting, affects performance

  theme = 'dark',           -- 'dark' or 'light'

  update_on_change = true,

  app = 'browser',          -- 'webview', 'browser', string or a table of strings
                            -- explained below

  filetype = { 'markdown' },-- list of filetypes to recognize as markdown

  -- relevant if update_on_change is true
  throttle_at = 200000,     -- start throttling when file exceeds this
                            -- amount of bytes in size
  throttle_time = 'auto',   -- minimum amount of time in milliseconds
                            -- that has to pass before starting new render
})
