return {
	"neomake/neomake",
	config = function()
		vim.g.neomake_open_list = 2
		vim.api.nvim_set_hl(0, "NeomakeError", { link = "DiagnosticError" })
		vim.api.nvim_set_hl(0, "NeomakeWarning", { link = "DiagnosticWarn" })
		vim.api.nvim_set_hl(0, "NeomakeInfo", { link = "DiagnosticInfo" })

		local keymaps = require("general.keymaps")
		keymaps.add({
			mode = "n",
			keys = "<leader>b",
			action = ":Neomake!<CR>",
			desc = "Build project",
		})
	end,
}
