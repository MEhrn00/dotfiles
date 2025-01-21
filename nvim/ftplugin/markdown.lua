if not vim.g.vscode then
	vim.opt_local.spell = true
end

-- Set tabs equal to 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- Bind `ga` to spell check
vim.api.nvim_buf_set_keymap(0, 'n', 'ga', 'z=', { noremap = true, silent = true })
