-- 'IDE mode' extra configuration

vim.g.ide_loaded = true

-- Set colors to signify change in mode
vim.cmd('colo codedark')

-- Make completions work better with nvim lsp
vim.opt.completeopt = 'menuone,longest,noselect,noinsert'

-- Right Click Context Menu (Copy-Cut-Paste) for gui
if vim.fn.exists('GuiLoaded') then
    keymap('n', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
    keymap('i', '<RightMouse>', '<Esc>:call GuiShowContextMenu()<CR>', { silent = true })
    keymap('v', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
end

-- Disable netrw and use nerdtree instead
vim.g.loaded_netrwPlugin = 1

-- Setup completion
local nvim_lsp = require'lspconfig'

local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<Tab>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },

    -- Installed sources
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
})

capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lsp Config
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)

-- Setup debugging
options = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<F3>", ":lua require'dapui'.toggle()<CR>", options)
vim.api.nvim_set_keymap("n", "<F4>", ":lua require'dap'.terminate()<CR>", options)
vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", options)
vim.api.nvim_set_keymap("n", "<F6>", ":lua require'dap'.step_over()<CR>", options)
vim.api.nvim_set_keymap("n", "<F7>", ":lua require'dap'.step_into()<CR>", options)
vim.api.nvim_set_keymap("n", "<F8>", ":lua require'dap'.step_out()<CR>", options)
vim.api.nvim_set_keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", options)
vim.api.nvim_set_keymap("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", options)
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", options)
vim.api.nvim_set_keymap("v", "<M-k>", ":lua require'dapui'.eval()<CR>", options)

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

-- Language configurations
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
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true
  },
}

require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
}

-- Format on save write hook
vim.cmd [[
augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cpp,*.c,*.h,*.py,*.tf silent! FormatWrite
augroup END
]]

-- Command keybinds for nvim lsp such as documentation and goto implementation
keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', { silent = true })
keymap('n', 'gD', 'vim.lsp.buf.implementation()', { silent = true, expr = true })
keymap('n', '<C-k>', 'vim.lsp.buf.signature_help()', { silent = true, expr = true })
keymap('n', '<leader>r', ':Telescope lsp_references<CR>', { silent = true })
keymap('n', 'ge', 'vim.lsp.diagnostic.goto_next()', { silent = true, expr = true })
keymap('n', 'gE', 'vim.lsp.diagnostic.goto_prev()', { silent = true, expr = true })
keymap('n', '<leader>e', ':Telescope lsp_workspace_diagnostics<CR>', { silent = true })
keymap('n', 'gd', 'vim.lsp.buf.declaration()', { silent = true, expr = true })
keymap('n', 'ga', ':lua vim.lsp.buf.code_action()<CR>', { silent = true })

-- Idk what this is I saw it on stack overflow I think
vim.opt.updatetime = 300

-- Idk
vim.opt.signcolumn = 'yes'

-- Open nerdtree with keybind
keymap('n', '<space>f', ':NERDTreeToggle<CR>', { silent = true })
