if has('win32')
    let plug_path = '$HOMEPATH/AppData/Local/nvim/plugged'
else
    let plug_path = '~/.config/nvim/plugged'
endif

call plug#begin(plug_path)

" Preview markdown files in web browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Toml syntax support
Plug 'cespare/vim-toml'

" Kotlin syntax support
Plug 'udalov/kotlin-vim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Colors
Plug 'tomasiser/vim-code-dark'
Plug 'sainnhe/edge'

" File browser
Plug 'preservim/nerdtree'

" Format on save
Plug 'mhartington/formatter.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

" Completion
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'williamboman/nvim-lsp-installer'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'leoluz/nvim-dap-go'
Plug 'mfussenegger/nvim-dap-python'

" Float Term
Plug 'voldikss/vim-floaterm'

call plug#end()
