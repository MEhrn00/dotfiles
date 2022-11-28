" 'IDE mode' extra configuration

let g:ide_loaded = 1

" Set colors to signify change in mode
let g:edge_style = 'aura'
colo codedark
hi clear MatchParen
hi MatchParen cterm=underline gui=underline

" Make completions work better with nvim lsp
set completeopt=menuone,longest,noselect,noinsert

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste) for gui
if exists('GuiLoaded')
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
endif

" Disable netrw and use nerdtree instead
let loaded_netrwPlugin = 1

lua <<EOF
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
vim.api.nvim_set_keymap("n", "<F2>", ":lua require'dapui'.toggle()<CR>", options)
vim.api.nvim_set_keymap("n", "<F6>", ":lua require'dap'.terminate()<CR>", options)
vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", options)
vim.api.nvim_set_keymap("n", "<F8>", ":lua require'dap'.step_over()<CR>", options)
vim.api.nvim_set_keymap("n", "<F9>", ":lua require'dap'.step_into()<CR>", options)
vim.api.nvim_set_keymap("n", "<F10>", ":lua require'dap'.step_out()<CR>", options)
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

EOF

" Format on save write hook
augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cpp,*.c,*.h,*.py,*.tf silent! FormatWrite
augroup END

" Floating terminal keybinds
nnoremap <silent> <F1> :FloatermToggle<CR>
inoremap <silent> <F1> <Esc>:FloatermToggle<CR>
vnoremap <silent> <F1> :FloatermToggle<CR>
tnoremap <silent> <F1> <C-\><C-n>:FloatermToggle<CR>

nnoremap <silent> <space>t :FloatermToggle<CR>

let g:floaterm_wintype='vsplit'

if has("win32")
    let g:floaterm_shell = 'powershell.exe'
else
    let g:floaterm_shell = 'zsh'
endif

" Command keybinds for nvim lsp such as documentation and goto implementation
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>r    :Telescope lsp_references<CR>
nnoremap <silent> ge    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gE    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <leader>e :Telescope lsp_workspace_diagnostics<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>


" Idk what this is I saw it on stack overflow I think
set updatetime=300
"autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Idk
set signcolumn=yes

" Open nerdtree with keybind (might get rid of in favor of telescope)
nnoremap <silent> <space>f :NERDTreeToggle<CR>
