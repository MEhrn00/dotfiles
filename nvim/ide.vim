" 'IDE mode' extra configuration

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
    GuiScrollBar 0
endif

" Right Click Context Menu (Copy-Cut-Paste) for gui
if has('gui_running')
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
endif

" Disable netrw and use nerdtree instead
let loaded_netrwPlugin = 1

lua <<EOF
-- Setup nvim lsp
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    require'completion'.on_attach(client)
end

-- Windows || linux config
if vim.fn.has('win32') == 1 then
    local rustlsp_cmd = "rust-analyzer.exe"
    local clangd_cmd = "clangd.exe"
else
    local rustlsp_cmd = "rust-analyzer"
    local clangd_cmd = "clangd"
end

-- Rust analyzer setup
require'lspconfig'.rust_analyzer.setup{
    cmd = { rustlspcmd },
    filetypes = { "rust" },
}

-- Golang setup
require'lspconfig'.gopls.setup{}

-- Clangd setup
require'lspconfig'.clangd.setup{
    cmd = { clangdcmd,
            "--background-index",
            "-Werror",
            "--clang-tidy",
            "--clang-tidy-checks='modernize-*,cert-*,performance-*,portability-*'",
            "--suggest-missing-includes"},

    filetypes = { "c", "cpp" }
}


-- Show lsp diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

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
                  args = {"-style=LLVM"},
                  stdin = true,
                  cwd = vim.fn.expand('%:p:h')
              }
          end
      },
    }
})

-- Launch nvim lsp automatically based on file type
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

" Format on save write hook
augroup Format
    autocmd!
    autocmd BufWritePost *.rs,*.go,*.cc,*.cpp silent! FormatWrite
augroup END

" Floating terminal
let g:floaterm_keymap_toggle = '<space>f'

if has("win32")
    let g:floaterm_shell = 'powershell.exe'
else
    let g:floaterm_shell = 'zsh'
endif

" Activate completion menu on <C-x><C-o>
imap <C-x><C-o> <Plug>(completion_smart_tab)

" Command keybinds for nvim lsp such as documentation and goto implementation
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

" Idk what this is I saw it on stack overflow I think
set updatetime=300
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Cycle nvim lsp diagnostic windows
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Idk
set signcolumn=yes

" Open nerdtree with keybind (might get rid of in favor of telescope)
nnoremap <silent> <space>f :NERDTreeToggle<CR>

" Disable neovide cursor animations if I'm using neovide
let g:neovide_cursor_animation_length=0
