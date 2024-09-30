return {
	"romgrk/barbar.nvim",
	dependencies = {},
	config = function()
		require("utils.keymaps").apply({
			{
				mode = "n",
				keys = "<leader>[",
				action = "<Cmd>BufferPrevious<CR>",
				desc = "Barbar go to to previous buffer",
			},
			{
				mode = "n",
				keys = "<leader>]",
				action = "<Cmd>BufferNext<CR>",
				desc = "Barbar go to to next buffer",
			},
			{
				mode = "n",
				keys = "<leader>z",
				action = "<Cmd>BufferMovePrevious<CR>",
				desc = "Barbar move buffer left",
			},
			{
				mode = "n",
				keys = "<leader>x",
				action = "<Cmd>BufferMoveNext<CR>",
				desc = "Barbar move buffer right",
			},
			{
				mode = "n",
				keys = "<leader>t",
				action = "<Cmd>BufferPick<CR>",
				desc = "Barbar pick buffer",
			},
			{
				mode = "n",
				keys = "<leader>d",
				action = "<Cmd>BufferClose<CR>",
				desc = "Barbar close buffer",
			},
			{
				mode = "n",
				keys = "<leader>1",
				action = "<Cmd>BufferGoto 1<CR>",
				desc = "Goto buffer 1",
			},
			{
				mode = "n",
				keys = "<leader>2",
				action = "<Cmd>BufferGoto 2<CR>",
				desc = "Goto buffer 2",
			},
			{
				mode = "n",
				keys = "<leader>3",
				action = "<Cmd>BufferGoto 3<CR>",
				desc = "Goto buffer 3",
			},
			{
				mode = "n",
				keys = "<leader>4",
				action = "<Cmd>BufferGoto 4<CR>",
				desc = "Goto buffer 4",
			},
			{
				mode = "n",
				keys = "<leader>5",
				action = "<Cmd>BufferGoto 5<CR>",
				desc = "Goto buffer 5",
			},
			{
				mode = "n",
				keys = "<leader>6",
				action = "<Cmd>BufferGoto 6<CR>",
				desc = "Goto buffer 6",
			},
			{
				mode = "n",
				keys = "<leader>7",
				action = "<Cmd>BufferGoto 7<CR>",
				desc = "Goto buffer 7",
			},
			{
				mode = "n",
				keys = "<leader>8",
				action = "<Cmd>BufferGoto 8<CR>",
				desc = "Goto buffer 8",
			},
			{
				mode = "n",
				keys = "<leader>9",
				action = "<Cmd>BufferGoto 9<CR>",
				desc = "Goto buffer 9",
			},
			{
				mode = "n",
				keys = "<leader>0",
				action = "<Cmd>BufferLast<CR>",
				desc = "Goto last buffer",
			},
		})
	end,
}
