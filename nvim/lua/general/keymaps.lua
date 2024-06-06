local M = {}

local keymaps = {
	-- Buffer handling
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

	-- Repeated tab shifting
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
		mode = "i",
		keys = "<C-c>",
		action = "<Esc>",
		desc = "Bind control C to escape in insert mode",
	},

	{
		mode = "v",
		keys = "<C-c>",
		action = "<Esc>",
		desc = "Bind control C to escape in visual mode",
	},

	{
		mode = "s",
		keys = "<C-c>",
		action = "<Esc>",
		desc = "Bind control C to escape in select mode",
	},

	{
		mode = "o",
		keys = "<C-c>",
		action = "<Esc>",
		desc = "Bind control C to escape in operator-pending mode",
	},

	-- Command mode emacs-keys
	{
		mode = "c",
		keys = "<C-a>",
		action = 'wildmenumode() ? "<lt>C-a>" : "<lt>Home>"',
		desc = "start of line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-b>",
		action = 'wildmenumode() ? "<lt>Up>" : "<lt>Left>"',
		desc = "back one character",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-d>",
		action = 'wildmenumode() ? "<lt>C-d>" : "<lt>Del>"',
		desc = "delete character under cursor",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-e>",
		action = 'wildmenumode() ? "<lt>C-e>" : "<lt>End>"',
		desc = "end of line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-f>",
		action = 'wildmenumode() ? "<lt>Down>" : "<lt>Right>"',
		desc = "forward one character",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-n>",
		action = 'wildmenumode() ? "<lt>Right>" : "<lt>Down>"',
		desc = "recall newer command-line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<C-p>",
		action = 'wildmenumode() ? "<lt>Left>" : "<lt>Up>"',
		desc = "recall previous (older) command-line",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<T-b>",
		action = 'wildmenumode() ? "" : "<lt>S-Left>"',
		desc = "back one word",
		opts = {
			silent = false,
			expr = true,
		},
	},

	{
		mode = "c",
		keys = "<T-f>",
		action = 'wildmenumode() ? "" : "<lt>S-Right>"',
		desc = "forward one word",
		opts = {
			silent = false,
			expr = true,
		},
	},

	-- System clipboard keybinds
	{
		mode = "n",
		keys = "<leader>y",
		action = '"+y',
		desc = "Copy to system clipboard",
	},

	{
		mode = "v",
		keys = "<leader>y",
		action = '"+y',
		desc = "Copy to system clipboard",
	},

	-- Terminal escape key
	{
		mode = "t",
		keys = "<Esc>",
		action = "<C-\\><C-n>",
		desc = "Escape out of terminal insert mode",
	},

	-- quick fix list
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

local default_options = {
	noremap = true,
	silent = true,
}

--- Adds a new keymap
-- @param keymap table containing the keymap
--
-- Format for the keymap table
-- ```lua
-- {
--   mode = '<mode abbreviation (n, v)>',
--   keys = '<key combination>',
--   action = '<action to perform>',
--   desc = '<description for the keybind>',
--
--   -- Optional extra keybind options :h map-arguments
--   opts = {
--     silent = '<keybind should be silent:bool>',
--     noremap = '<do not remap existing keybind:bool>',
--     expr = '<keybind action is an expression:bool>',
--   }
-- }
-- ```
function M.add(keymap)
	local opts = vim.tbl_extend("force", default_options, { desc = keymap["desc"] })

	if keymap["opts"] then
		opts = vim.tbl_extend("force", opts, keymap["opts"])
	end

	vim.keymap.set(keymap["mode"], keymap["keys"], keymap["action"], opts)
end

--- Applys an array of keymap tables
-- @param maptpl array of keymap tables to apply
--
-- Format for the table array
-- ```lua
-- {
--   {
--     mode = '<mode abbreviation (n, v)>',
--     keys = '<key combination>',
--     action = '<action to perform>',
--     desc = '<description for the keybind>',
--
--     -- Optional extra keybind options :h map-arguments
--     opts = {
--       silent = '<keybind should be silent:bool>',
--       noremap = '<do not remap exiting keybind:bool>',
--       expr = '<keybind action is an expression:bool>',
--       buffer = '<keymap is only for current buffer:bool>',
--     }
--   },
-- }
-- ```
function M.apply(maptbl)
	for _, k in ipairs(maptbl) do
		M.add(k)
	end
end

function M.setup()
	M.apply(keymaps)
end

return M
