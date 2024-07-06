return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			opts = {
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			},
			main = "window-picker",
			config = true,
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		local keymaps = require("utils.keymaps")

		keymaps.add({
			mode = "n",
			keys = "<space>f",
			action = ":Neotree toggle<CR>",
			desc = "Toggle Neotree",
		})
	end,
}
