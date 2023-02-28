-- Plugins
require('plugins')

-- Turn on line numbers
vim.opt.number = true

-- Set the scrolloff
vim.opt.scrolloff = 5

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

function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Screen buffer navigation
keymap('n', '<Leader>]', ':bn<CR>', { silent = true })
keymap('n', '<Leader>[', ':bp<CR>', { silent = true })
keymap('n', '<Leader>d', ':bd<CR>', { silent = true })

-- Multiple shifting using angle brackets
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- More natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set undo to only undo lines in insert mode
keymap('i', '<C-U>', '<C-G>u<C-U>')

-- Pwn snippet
local pwnsnippet = vim.fn.stdpath('config') .. '/snippets/skeleton-pwn.py'
if vim.fn.filereadable(pwnsnippet) then
    keymap('n', ',e', ':-1read ' .. pwnsnippet .. '<CR>3j$i', { silent = true })
end

-- Use '\y' to copy text to the system clipboard
keymap('n', '<Leader>y', '"+y')
keymap('v', '<Leader>y', '"+y')

-- Basic general completion settings
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.completeopt = 'menuone,longest'
vim.opt.shortmess = 'filnxtToOFc'

-- Live substitute
vim.opt.icm = 'nosplit'

-- Terminal escape
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Enable termdebug
vim.cmd [[packadd termdebug]]
vim.g.termdebug_wide = 1

-- Include .zshrc when issuing shell commands
vim.opt.shellcmdflag = '-ic'

-- Run ctags in the background using tgen if the tags file exists
if vim.fn.has('unix') then
    keymap('n', '<leader>c', ':!tgen<CR>', { silent = true })

    local function RunCtagsBack()
        if vim.fn.filereadable("tags") == 1 then
            vim.cmd(':execute \'silent !tgen\' | redraw!')
        end
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function() vim.schedule(RunCtagsBack) end,
    })
    --vim.cmd('autocmd BufWritePost * :call RunCtagsBack()')
end

-- Neovide settings
if vim.fn.has('win32') then
    vim.opt.guifont = 'Consolas:h9'
else
    vim.opt.guifont = 'Source Code Pro:h9'
end
vim.g.neovide_fullscreen = 'v:false'
vim.g.neovide_remember_window_size = 'v:true'
vim.g.neovide_cursor_vfx_mode = 'sonicboom'

-- Telescope keybinds
keymap('n', '<leader>t', ':Telescope tags<CR>', { silent = true })
keymap('n', '<leader>f', ':Telescope find_files<CR>', { silent = true })
keymap('n', '<leader>;', ':Telescope buffers<CR>', { silent = true })
keymap('n', '<leader>g', ':Telescope live_grep<CR>', { silent = true })
keymap('n', '<leader>s', ':Telescope grep_string<CR>', { silent = true })

-- Don't remove split if buffer is deleted
keymap('n', '<leader>d', ':bp|bd #<CR>', { silent = true})

-- Floating terminal keybinds
keymap('n', '<space>t', ':FloatermToggle<CR>', { silent = true })
keymap('n', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('i', '<F1>', '<Esc>:FloatermToggle<CR>', { silent = true })
keymap('v', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('t', '<F1>', '<C-\\><C-n>:FloatermToggle<CR>', { silent = true })

-- Bind make to F2
keymap('n', '<F2>', ':make<CR>', { silent = true })

-- Set floating terminal to be a vsplit
vim.g.floaterm_wintype = 'vsplit'

-- Set the terminal shell
--if vim.fn.has('win32') then
--    vim.g.floaterm_shell = 'powershell.exe'
--else
    vim.g.floaterm_shell = 'zsh'
--end

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

vim.api.nvim_create_user_command(
    'Ide',
    function()
        if not vim.g.ide_loaded then
            require('ide')
        end
    end,
    { desc = 'Setup IDE settings' }
)
