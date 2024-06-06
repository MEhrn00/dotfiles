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

local columnline_default_color = "darkgray"

-- habamax.vim
-- lunaperche.vim
-- retrobox
-- shine
-- sorbet
-- wildcharm
local default_opts = {
	colorscheme = "retrobox",
}

function M.setup(opts)
	-- Set the background to dark and allow gui colors in the terminal
	vim.opt.bg = "dark"
	vim.opt.termguicolors = true

	-- Combine default opts with input opts
	opts = vim.tbl_deep_extend("force", default_opts, opts or {})

	if opts.columnline ~= nil then
		if type(opts.columnline) == "string" then
			opts.columnline = { bg = opts.columnline }
		end
	else
		opts.columnline = { bg = columnline_default_color }
	end

	-- Set the colorscheme
	vim.cmd.colorscheme(opts.colorscheme)

	-- Set the column line color
	vim.api.nvim_set_hl(0, "ColorColumn", opts.columnline)

	-- Add transparency when in a terminal
	if not (vim.fn.has("gui") == 1) and not vim.g.neovide then
		for _, group in ipairs(transparent_groups) do
			local val = vim.api.nvim_get_hl(0, { name = group })
			if val.link ~= nil then
				val = vim.api.nvim_get_hl(0, { name = group, link = false })
			end

			local newval = vim.tbl_deep_extend("keep", { bg = "none", force = true }, val)
			vim.api.nvim_set_hl(0, group, newval)
		end
	end
end

return M
