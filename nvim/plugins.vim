call plug#begin('~/.config/nvim/plugged')

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'ctrlpvim/ctrlp.vim'

Plug 'jremmen/vim-ripgrep'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'cespare/vim-toml'

call plug#end()
