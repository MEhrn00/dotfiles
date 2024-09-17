local keybinds = {
	{
		mode = "n",
		keys = "<space>t",
		action = ":ToggleTerm<CR>",
		desc = "Open terminal",
	},
	{
		mode = "t",
		keys = "<C-g>",
		action = "<Cmd>:ToggleTerm<CR>",
		desc = "Close terminal",
	},
	{
		mode = "t",
		keys = "<C-w>k",
		action = "<Cmd>wincmd k<CR>",
		desc = "Go to above window",
	},
	{
		mode = "t",
		keys = "<C-w>h",
		action = "<Cmd>wincmd h<CR>",
		desc = "Go to left window",
	},
	{
		mode = "t",
		keys = "<C-w>l",
		action = "<Cmd>wincmd l<CR>",
		desc = "Go to right window",
	},
}

return {
	"akinsho/toggleterm.nvim",
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 20
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.5
			end
		end,

		shade_terminals = false,
		open_mapping = [[<F1>]],
		direction = "horizontal",
	},

	config = function(_, opts)
		require("toggleterm").setup(opts)
		require("utils.keymaps").apply(keybinds)
	end,
}
