filetype plugin indent on
filetype plugin on
syntax on

" Vim defaults
source /usr/share/vim/vim82/defaults.vim

" Plugins
source ~/.config/nvim/plugins.vim

" Turn on numbering
set number

" Whitespace
set list

" Turn on mouse
set mouse=a

" Set tabs equal to 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent

" Don't show mode cursor does that
set noshowmode
set noshowcmd

" Set color
let g:vscode_style = "dark"
colo vscode
set title
set bg=light
hi Pmenu ctermbg=235 ctermfg=white
hi Search ctermfg=black ctermbg=white
hi StatusLine ctermfg=0 ctermbg=white
hi StatusLineNC ctermfg=white ctermbg=black
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Cursor column
set cc=90
set tw=90
hi ColorColumn ctermbg=grey guibg=lightgrey

" Turn off search highlighting but on incsearch
set nohlsearch
set incsearch

" Status line
set laststatus=1

" Wildmenu
set path+=**
set wildmenu

" Screen buffer stuff
nnoremap <silent> <Leader>] :bn<CR>
nnoremap <silent> <Leader>[ :bp<CR>
nnoremap <silent> <Leader>; :buffers<CR>
nnoremap <silent> <Leader>d :bd<CR>

" More natural splitting
set splitbelow
set splitright

" Clipboard
noremap <Leader>y "+y

" General Completion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,noselect,noinsert
set shortmess+=c

" Live substitute
set icm=nosplit

" Terminal settings
tnoremap <Esc> <C-\><C-n>

" Enable termdebug
packadd termdebug
let g:termdebug_wide=1

" Ctags (needs to fix)
nnoremap <silent> <leader>c :!ctags.exe -R --exclude=target --exclude=env --exclude=.vscode .<CR>

" CtrlP
let g:ctrlp_cmd = 'CtrlPTag'
let g:ctrlp_working_path_mode = 'a'

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
    GuiScrollBar 0
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv

set laststatus=2

let loaded_netrwPlugin = 1

lua <<EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    require'completion'.on_attach(client)
end

require'lspconfig'.rust_analyzer.setup{
    cmd = { "rust-analyzer.exe" },
    filetypes = { "rust" },
}

require'lspconfig'.gopls.setup{}
require'lspconfig'.clangd.setup{
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp" }
}


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

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
                  args = {"-style=LLVM"},
                  stdin = true,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },
    }
})

local servers = { "rust_analyzer", "gopls", "clangd" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cc,*.cpp silent! FormatWrite
augroup END

let g:floaterm_keymap_toggle = '<space>f'
let g:floaterm_shell = 'powershell.exe'

imap <C-x><C-o> <Plug>(completion_smart_tab)

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

set signcolumn=yes

let g:airline_theme='tomorrow'

nnoremap <silent> <leader>f :NERDTreeToggle<CR>

let g:neovide_cursor_animation_length=0

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
