local M = {}

local function adjustfontsize(amt)
	vim.g.fontsize = vim.g.fontsize + amt
	vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)
end

function M.setup()
	if not vim.g.neovide then
		vim.g.fontsize = 5
		vim.g.neovide_hide_mouse_when_typing = true
	end

	-- Get the GUI font name for the platform
	if vim.fn.has("win32") == 1 then
		vim.g.guifontname = require("general.windows").guifont
	elseif vim.fn.has("unix") == 1 then
		vim.g.guifontname = require("general.linux").guifont
	end

	vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)

	local keymaps = require("general.keymaps")

	-- Increase font size
	keymaps.add({
		mode = "n",
		keys = "<C-ScrollWheelUp>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control scroll wheel up",
	})

	keymaps.add({
		mode = "n",
		keys = "<C-+>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control +",
	})

	keymaps.add({
		mode = "i",
		keys = "<C-ScrollWheelUp>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control scroll wheel up",
	})

	keymaps.add({
		mode = "i",
		keys = "<C-+>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control +",
	})

	-- Decrease font size
	keymaps.add({
		mode = "n",
		keys = "<C-ScrollWheelDown>",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control scroll wheel down",
	})

	keymaps.add({
		mode = "i",
		keys = "<C-ScrollWheelDown>",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control scroll wheel down",
	})

	keymaps.add({
		mode = "n",
		keys = "<C-->",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control -",
	})

	keymaps.add({
		mode = "i",
		keys = "<C-->",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control -",
	})

	-- Copy/Paste
	keymaps.add({
		mode = "i",
		keys = "<S-Insert>",
		action = '<Esc>"+pa',
		desc = "Paste system clipboard with shift insert",
	})

	keymaps.add({
		mode = "n",
		keys = "<S-Insert>",
		action = '"+px',
		desc = "Paste system clipboard with shift insert",
	})

	keymaps.add({
		mode = "i",
		keys = "<M-v>",
		action = '<Esc>"+pa',
		desc = "Paste system clipboard with alt v",
	})

	keymaps.add({
		mode = "n",
		keys = "<M-v>",
		action = '"+px',
		desc = "Paste system clipboard with alt v",
	})

	-- Right click context menu
	keymaps.add({
		mode = "n",
		keys = "<RightMouse>",
		action = ":call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	})

	keymaps.add({
		mode = "i",
		keys = "<RightMouse>",
		action = "<Esc>:call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	})

	keymaps.add({
		mode = "v",
		keys = "<RightMouse>",
		action = ":call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	})
end

return M
