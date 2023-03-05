-- Set the terminal shell
--if vim.fn.has('win32') then
--    vim.g.floaterm_shell = 'powershell.exe'
--else
vim.g.floaterm_shell = 'zsh'
--end

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

-- Git settings
local neogit = require('neogit')
neogit.setup{
  kind = "vsplit",
  integrations = {
    diffview = true
  }
}

-- Dev icons
require('nvim-web-devicons').setup()

-- Setup completion
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'rust_analyzer',
    'gopls',
    'clangd',
})

-- Setup LSP initialization status
require('fidget').setup{}

-- Setup Rust completion
lsp.configure('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            },

            cargo = {
                features = "all"
            }
        },
    }
})

--lsp.configure('clangd', {
--  settings = {
--    cmd = {
--      'clangd',
--      '-clang-tidy',
--      '-clang-tidy-checks=-*,clang-analyzer-*,modernize-*,readability-*'
--    }
--  }
--})

-- Set LSP preferences to not include sign icons
lsp.set_preferences({
    sign_icons = { }
})

-- Set code completion keybinds
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<CR>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
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
end)

-- Finish LSP setup
lsp.setup()
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

-- Setup status line
require('lualine').setup{
  options = {
    theme = 'nord'
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
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

-- Setup format on save for rust, go and c++
require('formatter').setup({
    logging = false,
    filetype = {
      go = {
          function()
              return {
                  exe = "gofmt",
                  stdin = true
          }
          end
      },

      rust = {
          function()
              return {
                  exe = "rustfmt",
                  args = {
                      "--emit=stdout",
                      "--edition=2021",
                      "--color=never",
                  },
                  stdin = true
              }
          end
      },

      cpp = {
          function()
              return {
                  exe = "clang-format",
                  args = {'-i', "-style=file"},
                  stdin = false,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },

      c = {
          function()
              return {
                  exe = "clang-format",
                  args = {'-i', '-style=file'},
                  stdin = false,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },

      python = {
          function()
              return {
                  exe = "black",
                  args = {"--no-color"},
                  stdin = false,
          }
          end
      },

      tf = {
          function()
              return {
                  exe = "terraform",
                  args = {"fmt", "-no-color", "-"},
                  stdin = true,
              }
          end
      },

    }
})

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

-- Format on save write hook
vim.cmd [[
augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cpp,*.c,*.h,*.py,*.tf silent! FormatWrite
augroup END
]]

-- Build task runner
require('overseer').setup()
