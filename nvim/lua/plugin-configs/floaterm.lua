-- Set the terminal shell
if vim.fn.has('win32') == 1 then
  vim.g.floaterm_shell = 'powershell.exe'
else
  vim.g.floaterm_shell = 'zsh'
end

-- Set floating terminal to be a vsplit
vim.g.floaterm_wintype = 'vsplit'

-- Floating terminal keybinds
keymap('n', '<space>t', ':FloatermToggle<CR>', { silent = true })
keymap('n', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('i', '<F1>', '<Esc>:FloatermToggle<CR>', { silent = true })
keymap('v', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('t', '<F1>', '<C-\\><C-n>:FloatermToggle<CR>', { silent = true })
