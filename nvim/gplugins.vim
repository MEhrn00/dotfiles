call plug#begin('$HOME/AppData/Local/nvim/plugged')

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Ripgrep
Plug 'jremmen/vim-ripgrep'

" Toml syntax highlighting
Plug 'cespare/vim-toml'

" Colors
Plug 'Mofiqul/vscode.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File browser
Plug 'preservim/nerdtree'

" Format on save
Plug 'mhartington/formatter.nvim'

" Completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Float Term
Plug 'voldikss/vim-floaterm'
Plug 'nvim-lua/popup.nvim'

call plug#end()
