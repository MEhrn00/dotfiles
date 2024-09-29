return {
	{
		mode = "v",
		keys = "<",
		action = "<gv",
		desc = "Shift left but stay in visual mode",
	},

	{
		mode = "v",
		keys = ">",
		action = ">gv",
		desc = "Shift right but stay in visual mode",
	},

	-- Bind C-c to escape
	{
		mode = "v",
		keys = "<C-c>",
		action = "<Esc>",
		desc = "Bind control C to escape in visual mode",
	},

	{
		mode = "v",
		keys = "<leader>y",
		action = '"+y',
		desc = "Copy to system clipboard",
	},
}
