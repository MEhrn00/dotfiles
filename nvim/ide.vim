" 'IDE mode' extra configuration

let g:ide_loaded = 1

" Set colors to signify change in mode
let g:vscode_style = "dark"
colo vscode
set title

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
                  args = {"--emit=stdout"},
                  stdin = true
              }
          end
      },

      cpp = {
          function()
              return {
                  exe = "clang-format",
                  args = {'-style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None, AllowShortBlocksOnASingleLine: Empty, AlignArrayOfStructures: Right, AlignConsecutiveMacros: Consecutive, AlignConsecutiveAssignments: None}"'},
                  stdin = true,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },

      c = {
          function()
              return {
                  exe = "clang-format",
                  args = {'-style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None, AllowShortBlocksOnASingleLine: Empty, AlignArrayOfStructures: Right, AlignConsecutiveMacros: Consecutive, AlignConsecutiveAssignments: None}"'},
                  stdin = true,
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

" Telescope grep
nnoremap <silent> <leader>g :Telescope live_grep<CR>

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

" Disable neovide cursor animations if I'm using neovide
let g:neovide_cursor_animation_length=0
