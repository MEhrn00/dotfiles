return {
	"nvim-treesitter/nvim-treesitter-context",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter",
			import = "plugins.modules.treesitter",
		},
	},
	main = "treesitter-context",
	config = true,
}
