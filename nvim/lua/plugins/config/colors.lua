return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("vscode")

		-- Restore the gray column line
		vim.api.nvim_set_hl(0, "ColorColumn", { bg = "gray" })
		vim.api.nvim_create_autocmd({ "ColorScheme" }, {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "ColorColumn", { bg = "gray" })
			end,
		})

		-- Make the background transparent if not in a GUI
		if not vim.g.neovide and not (vim.fn.has("gui") == 1) then
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "gray", bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		end
	end,
}
