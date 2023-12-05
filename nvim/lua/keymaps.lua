-- Helper function for mapping keys
function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Default screen buffer navigation (this gets overridden by Barbar when it is loaded)
keymap('n', '<Leader>]', ':bn<CR>', { silent = true })
keymap('n', '<Leader>[', ':bp<CR>', { silent = true })
keymap('n', '<Leader>d', ':bd<CR>', { silent = true })

-- Multiple tab shifting using angle brackets
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Set undo to only undo lines in insert mode
keymap('i', '<C-U>', '<C-G>u<C-U>')

-- Load pwn snippet
local pwnsnippet = vim.fn.stdpath('config') .. '/snippets/skeleton-pwn.py'
if vim.fn.filereadable(pwnsnippet) then
    keymap('n', ',e', ':-1read ' .. pwnsnippet .. '<CR>3j$i', { silent = true })
end

-- Use '\y' to copy text to the system clipboard
keymap('n', '<Leader>y', '"+y')
keymap('v', '<Leader>y', '"+y')

-- Set escape to be the terminal escape character
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Don't remove split if buffer is deleted
keymap('n', '<leader>d', ':bp|bd #<CR>', { silent = true})

-- Bind make to F2
keymap('n', '<F2>', ':make<CR>', { silent = true })

-- Right Click Context Menu (Copy-Cut-Paste) for gui
if vim.fn.exists('GuiLoaded') == 1 then
  keymap('n', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
  keymap('i', '<RightMouse>', '<Esc>:call GuiShowContextMenu()<CR>', { silent = true })
  keymap('v', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
end
