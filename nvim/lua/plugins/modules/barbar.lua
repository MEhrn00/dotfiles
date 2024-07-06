return {
	"romgrk/barbar.nvim",
	dependencies = {},
	config = function()
		local keymap = require("utils.keymaps")
		keymap.add({
			mode = "n",
			keys = "<leader>[",
			action = "<Cmd>BufferPrevious<CR>",
			desc = "Barbar move to previous buffer",
		})

		keymap.add({
			mode = "n",
			keys = "<leader>]",
			action = "<Cmd>BufferNext<CR>",
			desc = "Barbar move to next buffer",
		})

		keymap.add({
			mode = "n",
			keys = "<leader>d",
			action = "<Cmd>BufferClose<CR>",
			desc = "Barbar close buffer",
		})
	end,
}
