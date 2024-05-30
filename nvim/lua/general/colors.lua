local M = {}

function M.setup(scheme)
	-- Set the background to dark and allow gui colors in the terminal
	vim.opt.bg = "dark"
	vim.opt.termguicolors = true

	-- Set the column line color to gray
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "gray" })
	vim.api.nvim_create_autocmd({ "ColorScheme" }, {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "gray" })
		end,
	})
end

return M
