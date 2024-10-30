vim.g.guifontname = "SauceCodePro Nerd Font"

if vim.g.neovide ~= nil then
	vim.g.fontsize = 9
else
	vim.g.fontsize = 5
end

vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = "v:true"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_scale_factor = 1.0

vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)

local function adjustfontsize(amt)
	if vim.g.fontsize ~= nil then
		vim.g.fontsize = vim.g.fontsize + amt
		vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)
	end
end

local map = vim.keymap.set

map({"n", "i"}, "<C-ScrollShellUp>", function() adjustfontsize(1) end, { desc = "Increase font size", silent = true })
map({"n", "i"}, "<C-+>", function() adjustfontsize(1) end, { desc = "Increase font size", silent = true })

map({"n", "i"}, "<C-ScrollShellDown>", function() adjustfontsize(-1) end, { desc = "Decrease font size", silent = true })
map({"n", "i"}, "<C-->", function() adjustfontsize(-1) end, { desc = "Decrease font size", silent = true })

map("i", "<S-Insert>", '<Esc>"+pa', { desc = "Paste system clipboard", silent = true })
map("n", "<S-Insert>", '"+px', { desc = "Paste system clipboard", silent = true })
map("i", "<C-V>", '<Esc>"+pa', { desc = "Paste system clipboard", silent = true })

map({"n", "v"}, "<RightMouse>", ":call GuiShowContextMenu()<CR>", { desc = "Show context menu", silent = true })
map("i", "<RightMouse>", "<Esc>:call GuiShowContextMenu()<CR>", { desc = "Show context menu", silent = true })
