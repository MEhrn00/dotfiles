return {
	{
		mode = "n",
		keys = "<leader>]",
		action = ":bn<CR>",
		desc = "Switch to next buffer",
	},

	{
		mode = "n",
		keys = "<leader>[",
		action = ":bp<CR>",
		desc = "Switch to previous buffer",
	},

	{
		mode = "n",
		keys = "<leader>d",
		action = ":bp|bd #<CR>",
		desc = "Delete current buffer",
	},

	{
		mode = "n",
		keys = "<leader>y",
		action = '"+y',
		desc = "Copy to system clipboard",
	},

	{
		mode = "n",
		keys = "]q",
		action = ":cnext<CR>",
		desc = "Move to next item in the quickfix list",
	},

	{
		mode = "n",
		keys = "[q",
		action = ":cprev<CR>",
		desc = "Move to previous item in the quickfix list",
	},

	{
		mode = "n",
		keys = "[Q",
		action = ":cfirst<CR>",
		desc = "Move to first item in the quickfix list",
	},

	{
		mode = "n",
		keys = "]Q",
		action = ":clast<CR>",
		desc = "Move to last item in the quickfix list",
	},

	-- location list
	{
		mode = "n",
		keys = "]w",
		action = ":lnext<CR>",
		desc = "Move to next item in the location list",
	},

	{
		mode = "n",
		keys = "[w",
		action = ":lprev<CR>",
		desc = "Move to previous item in the location list",
	},

	{
		mode = "n",
		keys = "[W",
		action = ":lfirst<CR>",
		desc = "Move to first item in the location list",
	},

	{
		mode = "n",
		keys = "]W",
		action = ":llast<CR>",
		desc = "Move to last item in the location list",
	},
}
