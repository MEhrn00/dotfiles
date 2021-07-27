filetype plugin indent on
filetype plugin on
syntax on

" Source the vim8 defaults for file location caching, scrolloff and other stuff
if has("unix")
    if filereadable(glob("/usr/share/vim/vim8*/defaults.vim"))
        exe 'source' glob("/usr/share/vim/vim8*/defaults.vim")
    endif
elseif has("win32")
    echo "Neeed to source defaults"
endif

" Plugins
if has("unix")
    if filereadable(glob("~/.config/nvim/plugins.vim"))
        exe 'source' glob("~/.config/nvim/plugins.vim")
    endif
elseif has("win32")
    echo "Need to source plugins"
endif

" Turn on numbering
set number

" Show trailng whitespace as '-' and hard tabs as '>'
set list
set listchars=tab:>\ ,trail:-

" Turn on mouse
set mouse=a

" Disable netrw history
let g:netrw_dirhistmax = 0

" Set tabs equal to 4 spaces by default
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent

" Don't show mode cursor does that
set noshowmode
set noshowcmd

" Set colors
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

" Column line and text wrapping
set cc=90
set tw=90
hi ColorColumn ctermbg=grey guibg=lightgrey

" Turn off search highlighting but turn incremental search on
set nohlsearch
set incsearch

" Disable neovim status line because it's ugly
set laststatus=0

" Wildmenu
set path+=**
set wildmenu

" Screen buffer navigation
nnoremap <silent> <Leader>] :bn<CR>
nnoremap <silent> <Leader>[ :bp<CR>
nnoremap <silent> <Leader>d :bd<CR>

" More natural splitting
set splitbelow
set splitright

" Pwn snippet
if filereadable(glob("~/.config/nvim/snippets/skeleton-pwn.py"))
    nnoremap <silent> ,e :-1read $HOME/.config/nvim/snippets/skeleton-pwn.py<CR>3j$i
else
    nnoremap <silent> ,e :echo "Pwn snippet not found"<CR>
endif

" Use '\y' to copy text to system clipboard
noremap <Leader>y "+y

" General Completion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest
set shortmess+=c

" Live substitute
set icm=nosplit

" Write sudo
if has("unix")
    cmap WW w !pkexec tee %
endif

" Terminal settings
tnoremap <Esc> <C-\><C-n>

" Enable termdebug
packadd termdebug
let g:termdebug_wide=1

" Ctags setup to run ctags in the background on save using `tgen` zsh alias if the tags file exists
if has("unix")
    nnoremap <silent> <leader>c :!zsh -ic tgen<CR>
    function! RunCtagsBack()
        if filereadable("tags")
            :execute 'silent !zsh -ic tgen &' | redraw!
        endif
    endfunction
    autocmd BufWritePost * :call RunCtagsBack()
endif

" Telescope keybinds
nnoremap <silent> <leader>t :Telescope tags<CR>
nnoremap <silent> <leader>f :Telescope find_files<CR>
nnoremap <silent> <leader>; :Telescope buffers<CR>

lua << EOF
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
EOF

" Function to setup ide configuration
function! IdeSetup()
    if filereadable(glob("~/.config/nvim/ide.vim"))
        exe 'source' glob("~/.config/nvim/ide.vim")
    else
        echo "Ide.vim not found"
    endif
endfunction
command Ide call IdeSetup()
