return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("utils.colors").apply_colorscheme("vscode")
	end,
}
