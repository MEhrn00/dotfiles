return {
	"nvim-treesitter/nvim-treesitter-context",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter",
			import = "lazy-plugins.plugins.treesitter",
		},
	},
	main = "treesitter-context",
	config = true,
}
