return {
	{
		mode = "c",
		keys = "<C-f>",
		action = 'wildmenumode() ? "<lt>Down>" : "<lt>Right>"',
		desc = "Move forward one character",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-b>",
		action = 'wildmenumode() ? "<lt>Up>" : "<lt>Left>"',
		desc = "Move backward one character",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-n>",
		action = 'wildmenumode() ? "<lt>Right>" : "<lt>Down>"',
		desc = "Move down to next wildmenu entry",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-p>",
		action = 'wildmenumode() ? "<lt>Left>" : "<lt>Up>"',
		desc = "Move up to previous wildmenu entry",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-a>",
		action = 'wildmenumode() ? "<lt>C-a>" : "<lt>Home>"',
		desc = "Move to the beginning of the line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-e>",
		action = 'wildmenumode() ? "<lt>C-e>" : "<lt>End>"',
		desc = "Move to the end of the line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<esc>f",
		action = 'wildmenumode() ? "" : "<lt>S-Right>"',
		desc = "Move foward one word",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<esc>b",
		action = 'wildmenumode() ? "" : "<lt>S-Left>"',
		desc = "Move backward one word",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-d>",
		action = 'wildmenumode() ? "<lt>C-d>" : "<lt>Del>"',
		desc = "Delete the character after point",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-k>",
		action = function()
			local idx = vim.fn.getcmdpos()
			local cmdlen = vim.fn.getcmdline():len()
			if cmdlen == idx then
				return ""
			end

			return string.rep("<Del>", cmdlen - idx + 1)
		end,
		desc = "Delete to the end of the line",
		opts = {
			silent = false,
			expr = true,
		},
	},
}
