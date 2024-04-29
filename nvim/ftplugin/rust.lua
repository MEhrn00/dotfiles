-- Set cursor column and text width to 80 characters
vim.opt_local.colorcolumn = '80'
vim.opt_local.textwidth = 80
vim.cmd.compiler('cargo')
