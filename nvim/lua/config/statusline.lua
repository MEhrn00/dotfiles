local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "V-LINE",
	[""] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	[""] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}


local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format("%s", modes[current_mode]):upper()
end

local function filepath()
	local fpath = vim.fn.expand("%:~:.")
	if fpath == nil or fpath == "" then
		return "[No Name]"
	end

	return fpath
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return "%3l:%-2c"
end

local function indentation()
	local tabstyle = ""
	if vim.bo.expandtab then
		tabstyle = "space"
	else
		tabstyle = "tab"
	end

	return string.format("%s:%d", tabstyle, vim.bo.tabstop)
end

local function encoding()
	if vim.bo.fileencoding == nil or vim.bo.fileencoding == "" then
		return ""
	end

	return vim.bo.fileencoding
end

Statusline = {}

function Statusline.active()
	return table.concat({
		mode(), " ", filepath(),
		"%=",
		" ",
		encoding(), " ", indentation(), " ", lineinfo(),
	})
end

function Statusline.inactive()
	return table.concat({
		filepath(),
		"%=",
		" ",
		lineinfo()
	})
end

local statuslinegroup = vim.api.nvim_create_augroup("Statusline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	pattern = "*",
	group = statuslinegroup,
	command = "setlocal statusline=%!v:lua.Statusline.active()",
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	pattern = "*",
	group = statuslinegroup,
	command = "setlocal statusline=%!v:lua.Statusline.inactive()",
})
