local M = {}

local transparent_groups = {
	"Normal",
	"NonText",
	"LineNr",
	"SignColumn",
	"ErrorMsg",
	"WarningMsg",
	"EndOfBuffer",
	"VertSplit",
}

local columnline_color = "darkgray"

local function apply_columnline_colors(color)
	if type(color) == "string" then
		color = { bg = color }
	end

	vim.api.nvim_set_hl(0, "ColorColumn", color)
end

local function apply_transparency()
	for _, group in ipairs(transparent_groups) do
		local val = vim.api.nvim_get_hl(0, { name = group })
		if val.link ~= nil then
			val = vim.api.nvim_get_hl(0, { name = group, link = false })
		end

		local newval = vim.tbl_deep_extend("keep", { bg = "none", force = true }, val)
		vim.api.nvim_set_hl(0, group, newval)
	end
end

function M.apply_colorscheme(colorscheme)
	if colorscheme ~= nil then
		vim.cmd.colorscheme(colorscheme)
		apply_columnline_colors(columnline_color)

		local gui = require("utils.gui")
		if gui.in_terminal() then
			apply_transparency()
		end
	end
end

return M
