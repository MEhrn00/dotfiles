local M = {}

function M.setup(opts)
	require("custom-plugins.bettermake").setup(opts)
	require("utils.keymaps").apply({
		{
			mode = "n",
			keys = "<leader>bc",
			action = ":BetterMakeCompile<CR>",
			desc = "Compile project",
		},

		{
			mode = "n",
			keys = "<leader>bb",
			action = ":BetterMakeRecompile<CR>",
			desc = "Recompile project",
		},
	})
end

return M
