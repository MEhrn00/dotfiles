local keybinds = {
	{
		mode = "n",
		keys = "<leader>e",
		action = ":OverseerToggle<CR>",
		desc = "Toggle Overseer window",
	},

	{
		mode = "n",
		keys = "<leader>b",
		action = ":OverseerRun<CR>",
		desc = "Run Overseer task",
	},
}

return {
	"stevearc/overseer.nvim",
	dependencies = {
		{
			"akinsho/toggleterm.nvim",
			import = "plugins.modules.toggleterm",
		},
	},

	opts = {
		templates = {
			"builtin",
			"custom.cmake",
			"custom.meson",
		},
	},

	config = function(_, opts)
		require("overseer").setup(opts)
		local keymaps = require("utils.keymaps")
		keymaps.apply(keybinds)
	end,
}
