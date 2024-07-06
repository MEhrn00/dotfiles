local M = {}

local linux_font = "SauceCodePro Nerd Font"
local windows_font = "SauceCodePro Nerd Font"

local function adjustfontsize(amt)
	if vim.g.fontsize ~= nil then
		vim.g.fontsize = vim.g.fontsize + amt
		vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)
	end
end

local guikeybinds = {
	-- Increase font size
	{
		mode = "n",
		keys = "<C-ScrollWheelUp>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control+scroll wheel up",
	},

	{
		mode = "n",
		keys = "<C-+>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control +",
	},

	{
		mode = "i",
		keys = "<C-ScrollWheelUp>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control scroll wheel up",
	},

	{
		mode = "i",
		keys = "<C-+>",
		action = function()
			adjustfontsize(1)
		end,
		desc = "Increase font size with control +",
	},

	-- Decrease font size
	{
		mode = "n",
		keys = "<C-ScrollWheelDown>",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control scroll wheel down",
	},

	{
		mode = "i",
		keys = "<C-ScrollWheelDown>",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control scroll wheel down",
	},

	{
		mode = "n",
		keys = "<C-->",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control -",
	},

	{
		mode = "i",
		keys = "<C-->",
		action = function()
			adjustfontsize(-1)
		end,
		desc = "Decrease font size with control -",
	},

	-- Copy/Paste
	{
		mode = "i",
		keys = "<S-Insert>",
		action = '<Esc>"+pa',
		desc = "Paste system clipboard with shift insert",
	},

	{
		mode = "n",
		keys = "<S-Insert>",
		action = '"+px',
		desc = "Paste system clipboard with shift insert",
	},

	{
		mode = "i",
		keys = "<M-v>",
		action = '<Esc>"+pa',
		desc = "Paste system clipboard with alt v",
	},

	{
		mode = "n",
		keys = "<M-v>",
		action = '"+px',
		desc = "Paste system clipboard with alt v",
	},
}

local nvimqtkeybinds = {
	-- Right click context menu
	{
		mode = "n",
		keys = "<RightMouse>",
		action = ":call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	},

	{
		mode = "i",
		keys = "<RightMouse>",
		action = "<Esc>:call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	},

	{
		mode = "v",
		keys = "<RightMouse>",
		action = ":call GuiShowContextMenu()<CR>",
		desc = "Show context menu",
	},
}

local function configuregui()
	vim.g.fontsize = 5
	vim.g.neovide_hide_mouse_when_typing = true

	-- Get the GUI font name for the platform
	local osutils = require("utils.os")
	if osutils.is_win32() then
		vim.g.guifontname = windows_font
	elseif osutils.is_unix() then
		vim.g.guifontname = linux_font
	end

	vim.opt.guifont = string.format("%s:h%d", vim.g.guifontname, vim.g.fontsize)

	local keymaps = require("utils.keymaps")
	keymaps.apply(nvimqtkeybinds)
end

function M.setup()
	local guiutils = require("utils.gui")

	if guiutils.in_gui() then
		local keymaps = require("utils.keymaps")
		keymaps.apply(guikeybinds)
	end

	if guiutils.has_gui() and not guiutils.has_neovide() then
		configuregui()
	end
end

return M
