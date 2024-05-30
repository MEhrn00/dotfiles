return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	opts = {
		ensure_installed = { "c", "rust", "go", "vim", "vimdoc", "lua" },
		auto_install = true,
		highlight = {
			enable = true,
		},
	},

	main = "nvim-treesitter.configs",
	config = true,
}
