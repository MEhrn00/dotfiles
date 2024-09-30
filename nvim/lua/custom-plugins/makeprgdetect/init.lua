local M = {}

local function get_pluginlist()
	local configpath = vim.fn.stdpath("config")
	local configdir = ""
	if type(configpath) == "string" then
		configdir = configpath
	elseif type(configpath) == "table" then
		configdir = configpath[0]
	end

	local pluginpath = vim.fs.joinpath(configdir, "lua", "custom-plugins", "makeprgdetect")
	local pluginlist = {}
	for name, type in vim.fs.dir(pluginpath) do
		name = name:gsub("%.lua$", "")
		if type == "file" or type == "directory" then
			name = name:gsub("%.lua$", "")

			if name ~= "init" then
				table.insert(pluginlist, name)
			end
		end
	end

	return pluginlist
end

function M.detect(makeprgs)
	if M.loaded ~= nil then
		return
	end

	if M.pluginlist == nil then
		M.pluginlist = get_pluginlist()
	end

	local fmod = vim.iter(makeprgs):find(function(val)
		return vim.iter(M.pluginlist):find(val)
	end)

	if fmod ~= nil then
		require("custom-plugins.makeprgdetect." .. fmod)
		M.loaded = true
	end
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", {}, opts or {})
	M.ftlist = opts.ft
end

return M
