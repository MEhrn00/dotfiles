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
                  args = {'-style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None, AlignArrayOfStructures: Right, AlignConsecutiveMacros: Consecutive, AlignConsecutiveAssignments: None}"'},
                  stdin = true,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },

      c = {
          function()
              return {
                  exe = "clang-format",
                  args = {'-style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None, AlignArrayOfStructures: Right, AlignConsecutiveMacros: Consecutive, AlignConsecutiveAssignments: None}"'},
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

    }
})
EOF

" Format on save write hook
augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cpp,*.c,*.h,*.py silent! FormatWrite
augroup END

" Floating terminal keybinds
nnoremap <silent> <F5> :FloatermToggle<CR>
inoremap <silent> <F5> <Esc>:FloatermToggle<CR>
vnoremap <silent> <F5> :FloatermToggle<CR>
tnoremap <silent> <F5> <C-\><C-n>:FloatermToggle<CR>

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
