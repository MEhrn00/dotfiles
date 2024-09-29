local M = {}

function M.setup()
	local configbase = vim.fn.stdpath("config")
	local configpath = ""
	if type(configbase) == "string" then
		configpath = configbase
	elseif type(configbase) == "table" then
		configpath = configbase[0]
	end

	local keymaps = require("utils.keymaps")

	for name, t in vim.fs.dir(vim.fs.joinpath(configpath, "lua", "general", "keybinds")) do
		if t == "file" then
			name = name:gsub("%.lua$", "")

			if name ~= "init" then
				keymaps.apply(require("general.keybinds." .. name))
			end
		end
	end
end

return M
