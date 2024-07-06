local M = {}

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

return M
