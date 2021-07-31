if has('win32')
    let plug_path = '$HOMEPATH/AppData/Local/nvim/plugged'
else
    let plug_path = '~/.config/nvim/pluged'
endif

call plug#begin(plug_path)

" Preview markdown in web browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Ripgrep
Plug 'jremmen/vim-ripgrep'

" Toml syntax support
Plug 'cespare/vim-toml'

" Kotlin syntax support
Plug 'udalov/kotlin-vim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Colors for IDE
Plug 'Mofiqul/vscode.nvim'

" File browser for IDE
Plug 'preservim/nerdtree'

" Format on save for IDE
Plug 'mhartington/formatter.nvim'

" Completion for IDE
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Float Term for IDE
Plug 'voldikss/vim-floaterm'
Plug 'nvim-lua/popup.nvim'

call plug#end()
