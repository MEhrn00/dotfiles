local M = {}

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

local basecolors = {
	darktext = "#222324",
	lighttext = "#ffffff",

	innerbg = "#4c566a",
	trimbg = "#3b4252",
}

local mode_colors = {
	["NORMAL"] = { fg = basecolors["darktext"], bg = "#91ddff" },
	["VISUAL"] = { fg = basecolors["darktext"], bg = "#77b869" },
	["V-LINE"] = { fg = basecolors["darktext"], bg = "#77b869" },
	["V-BLOCK"] = { fg = basecolors["darktext"], bg = "#77b869" },
	["SELECT"] = { fg = basecolors["darktext"], bg = "#ffffff" },
	["S-LINE"] = { fg = basecolors["darktext"], bg = "#ffffff" },
	["S-BLOCK"] = { fg = basecolors["darktext"], bg = "#ffffff" },
	["INSERT"] = { fg = basecolors["darktext"], bg = "#ffffff" },
	["REPLACE"] = { fg = basecolors["darktext"], bg = "#ebcb8b" },
	["V-REPLACE"] = { fg = basecolors["darktext"], bg = "#ebcb8b" },
	["COMMAND"] = { fg = basecolors["darktext"], bg = "#ebcb8b" },
}

local function update_mode_colors()
	local current_mode = modes[vim.api.nvim_get_mode().mode]:upper()

	local color = mode_colors["NORMAL"]
	if mode_colors[current_mode] ~= nil then
		color = mode_colors[current_mode]
	end

	vim.api.nvim_set_hl(0, "StatuslineOuter", color)
	vim.api.nvim_set_hl(0, "StatuslineOuterTrim", { fg = color["bg"], bg = basecolors["trimbg"] })
	vim.api.nvim_set_hl(0, "StatuslineOuterAlt", { fg = color["bg"], bg = basecolors["innerbg"] })
end

local rarrow = ""
local rarrow_thin = ""

local larrow = ""
local larrow_thin = ""

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format("%s", modes[current_mode]):upper()
end

local function filepath()
	local fpath = vim.fn.expand("%:.:h")
	if fpath == "" or fpath == "." then
		return ""
	end

	local separator = "/"
	if vim.fn.has("win32") then
		separator = "\\"
	end

	return fpath .. separator
end

local function filename()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		return "[No Name]"
	end
	return fname
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

local function lspinfo()
	local count = {}
	local levels = {
		errors = "Error",
		warnings = "Warn",
	}

	if not vim.lsp.buf.server_ready() then
		return "%#StatuslineOuterAlt#" .. rarrow
	end

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local errors = "%#StatuslineLspError#✗ "
	local warnings = "%#StatuslineLspWarning#▲ "

	if count["errors"] ~= 0 then
		errors = errors .. count["errors"]
	else
		errors = errors .. "0"
	end

	if count["warnings"] ~= 0 then
		warnings = warnings .. count["warnings"]
	else
		warnings = warnings .. count["warnings"]
	end

	return table.concat({
		"%#StatuslineOuterTrim#",
		rarrow,
		"%#StatuslineTrim#",
		" ",
		errors .. " " .. warnings,
		" ",
		"%#StatuslineTrimAlt#",
		rarrow,
	})
end

local function encoding()
	if vim.bo.fileencoding == nil or vim.bo.fileencoding == "" then
		return ""
	end

	return table.concat({
		string.format("%s", vim.bo.fileencoding),
		" ",
		larrow_thin,
	})
end

local function rightinner()
	if vim.bo.filetype == nil or vim.bo.filetype == "" then
		return table.concat({
			"%#StatuslineTrimAlt#",
			larrow,
			"%#StatuslineTrim#",
			" ",
			vim.bo.fileformat,
		})
	end

	return table.concat({
		larrow_thin,
		" ",
		string.format("%s", vim.bo.fileformat),
		" ",
		"%#StatuslineTrimAlt#",
		larrow,
		"%#StatuslineTrim#",
		" ",
		string.format("%s", vim.bo.filetype:gsub("^%l", string.upper)),
	})
end

function M.setup()
	vim.api.nvim_set_hl(0, "StatuslineOuter", mode_colors["NORMAL"])
	vim.api.nvim_set_hl(0, "StatuslineOuterAlt", { fg = mode_colors["NORMAL"]["bg"], bg = basecolors["innerbg"] })
	vim.api.nvim_set_hl(0, "StatuslineOuterTrim", { fg = mode_colors["NORMAL"]["bg"], bg = basecolors["trimbg"] })

	vim.api.nvim_set_hl(0, "Statusline", { fg = basecolors["lighttext"], bg = basecolors["innerbg"] })

	vim.api.nvim_set_hl(0, "StatuslineTrimAlt", { fg = basecolors["trimbg"], bg = basecolors["innerbg"] })
	vim.api.nvim_set_hl(0, "StatuslineTrim", { fg = basecolors["lighttext"], bg = basecolors["trimbg"] })

	vim.api.nvim_set_hl(0, "StatuslineLspError", { fg = "LightRed", bg = basecolors["trimbg"] })
	vim.api.nvim_set_hl(0, "StatuslineLspWarning", { fg = "LightYellow", bg = basecolors["trimbg"] })

	Statusline = {}

	Statusline.active = function()
		update_mode_colors()
		return table.concat({
			"%#StatuslineOuter#",
			" ",
			mode(),
			" ",
			lspinfo(),
			"%#Statusline#",
			" ",
			filepath(),
			filename(),
			"%=",
			" ",
			encoding(),
			" ",
			indentation(),
			" ",
			rightinner(),
			" ",
			"%#StatuslineOuterTrim#",
			larrow,
			"%#StatuslineOuter#",
			lineinfo(),
			" ",
		})
	end

	function Statusline.inactive()
		return table.concat({
			"%#Statusline#",
			" ",
			filepath(),
			filename(),
			"%=",
			lineinfo(),
			" ",
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
end

return M
