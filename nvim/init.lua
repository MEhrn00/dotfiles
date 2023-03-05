-- Plugins
require('plugins')

-- Keybindings
require('keymaps')

-- Turn on line numbers
vim.opt.number = true

-- Set the scrolloff
vim.opt.scrolloff = 5

-- Set the colorscheme
vim.cmd('colo codedark')

-- Save cursor position in file
vim.cmd [[
augroup vimStartup
    au!
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
]]

-- Show trailing whitespace as '-' and hard tabs as '>'
vim.opt.list = true
vim.opt.listchars = 'tab:> ,trail:-'

-- Turn on mouse
vim.opt.mouse = 'a'

-- Set the title to display the file name
vim.opt.title = true

-- Disable netrw history
vim.g.netrw_dirhistmax = 0

-- Set tabs equal to 4 spaces by default
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Don't show mode
vim.opt.showmode = false
vim.opt.showcmd = false

-- Set colors
vim.opt.bg = 'dark'
vim.opt.termguicolors = true

local highlights = {
    {'Pmenu', { ctermbg = 235, ctermfg = 'white', guibg = 235, guifg = 'white' }},
    {'MatchParen', { cterm = 'underline', gui = 'underline' }},
    {'Search', { ctermfg = 'black', ctermbg = 'white' }},
    {'StatusLine', { ctermfg = 'black', ctermbg = 'white' }},
    {'StatusLineNC', { ctermfg = 'white', ctermbg = 'black' }},
    {'ColorColumn', { ctermbg = 'lightgrey', guibg = 'lightgrey' }},
}

local set_highlight = function(group, opts)
    local ctermbg = opts.ctermbg == nil and '' or 'ctermbg=' .. opts.ctermbg
    local ctermfg = opts.ctermfg == nil and '' or 'ctermfg=' .. opts.ctermfg
    local guibg = opts.guibg == nil and '' or 'guibg=' .. opts.guibg
    local guifg = opts.guifg == nil and '' or 'guifg=' .. opts.guifg
    local cterm = opts.cterm == nil and '' or 'cterm=' .. opts.cterm
    local gui = opts.gui == nil and '' or 'gui=' .. opts.gui

    vim.cmd(string.format('hi %s %s %s %s %s %s %s', group, cterm, gui, ctermbg, ctermfg, guibg, guifg))
end

vim.cmd('hi clear MatchParen')
for _, highlight in ipairs(highlights) do
    set_highlight(highlight[1], highlight[2])
end

-- Column line and text wrapping
vim.opt.colorcolumn = '90'
vim.opt.textwidth = 90

-- Turn off search highlighting but turn incremental search on
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Disable neovim status line
vim.opt.laststatus = 1

-- Set the 'gf' search paths
vim.opt.path = {
    '.',
    '/usr/include',
    '**',
}

-- Turn on the wildmenu
vim.opt.wildmenu = true

-- More natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Basic general completion settings
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.completeopt = 'menuone,longest'
vim.opt.shortmess = 'filnxtToOFc'

-- Live substitute
vim.opt.icm = 'nosplit'

-- Enable termdebug
vim.cmd [[packadd termdebug]]
vim.g.termdebug_wide = 1

-- Include .zshrc when issuing shell commands
vim.opt.shellcmdflag = '-ic'

-- Neovide settings
if vim.fn.has('win32') then
    vim.opt.guifont = 'Consolas:h9'
else
    vim.opt.guifont = 'Source Code Pro:h9'
end
vim.g.neovide_fullscreen = 'v:false'
vim.g.neovide_remember_window_size = 'v:true'
vim.g.neovide_cursor_vfx_mode = 'sonicboom'

-- Make completions work better with nvim lsp
vim.opt.completeopt = 'menuone,longest,noselect,noinsert'

-- Disable netrw and use nerdtree instead
vim.g.loaded_netrwPlugin = 1


-- Idk what this is I saw it on stack overflow I think
vim.opt.updatetime = 300

-- Idk
vim.opt.signcolumn = 'yes'

-- Settings for extensions
require('extsettings')

