filetype plugin indent on
filetype plugin on
syntax on

" Vim defaults
source /usr/share/vim/vim82/defaults.vim

" Plugins
source ~/.config/nvim/plugins.vim

" Turn on numbering
set number

" Show trailng whitespace as a '-'
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
colo delek
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
set laststatus=0
let g:loaded_airline = 1

" Wildmenu
set path+=**
set wildmenu

" Screen buffer stuff
nnoremap <silent> <Leader>] :bn<CR>
nnoremap <silent> <Leader>[ :bp<CR>
nnoremap <silent> <Leader>d :bd<CR>

" More natural splitting
set splitbelow
set splitright

" Pwn snippet
nnoremap <silent> ,e :-1read $HOME/.config/nvim/snippets/skeleton-pwn.py<CR>3j$i

" Clipboard
noremap <Leader>y "+y

" General Completion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest
set shortmess+=c

" Live substitute
set icm=nosplit

" Write sudo
cmap WW w !pkexec tee %

" Terminal settings
tnoremap <Esc> <C-\><C-n>

" Enable termdebug
packadd termdebug
let g:termdebug_wide=1

" Ctags
nnoremap <silent> <leader>c :!zsh -ic tgen<CR>

function! RunCtagsBack()
    if filereadable("tags")
        :execute 'silent !zsh -ic tgen &' | redraw!
    endif
endfunction
autocmd BufWritePost * :call RunCtagsBack()

" Telescope
nnoremap <silent> <leader>t :Telescope tags<CR>
nnoremap <silent> <leader>f :Telescope find_files<CR>
nnoremap <silent> <leader>; :Telescope buffers<CR>

lua << EOF
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
EOF

function! IdeSetup()
    source ~/.config/nvim/ide.vim
endfunction
command Ide call IdeSetup()
