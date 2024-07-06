return {
	"neomake/neomake",
	config = function()
		vim.g.neomake_open_list = 2
		vim.api.nvim_set_hl(0, "NeomakeError", { link = "DiagnosticError" })
		vim.api.nvim_set_hl(0, "NeomakeWarning", { link = "DiagnosticWarn" })
		vim.api.nvim_set_hl(0, "NeomakeInfo", { link = "DiagnosticInfo" })
	end,
}
