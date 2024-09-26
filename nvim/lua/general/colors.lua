local M = {}

-- Good default color schemes
-- habamax
-- lunaperche
-- retrobox
-- shine
-- sorbet
-- wildcharm

function M.setup(opts)
	-- Set the background to dark and allow gui colors in the terminal
	vim.opt.bg = "dark"
	vim.opt.termguicolors = true

	-- Set the colorscheme
	if opts ~= nil and opts.colorscheme ~= nil then
		require("utils.colors").apply_colorscheme(opts.colorscheme)
	end
end

return M
