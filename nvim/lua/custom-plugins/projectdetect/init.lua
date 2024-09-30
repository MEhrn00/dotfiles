local M = {}

local function get_compilers()
	local rtps = vim.api.nvim_list_runtime_paths()

	return {}
end

local function get_modulelist()
	local configpath = vim.fn.stdpath("config")
	local configdir = ""
	if type(configpath) == "string" then
		configdir = configpath
	elseif type(configpath) == "table" then
		configdir = configpath[0]
	end

	local modulepath = vim.fs.joinpath(configdir, "lua", "custom-plugins", "makeprgdetect", "modules")
	local modulelist = {}
	for name, type in vim.fs.dir(modulepath) do
		name = name:gsub("%.lua$", "")
		if type == "file" or type == "directory" then
			name = name:gsub("%.lua$", "")

			if name ~= "init" then
				table.insert(modulelist, name)
			end
		end
	end

	return modulelist
end

function M.detect_command(compile_command)
	-- TODO
end

function M.detect_modules(modules)
	if M.loaded ~= nil then
		return
	end

	if M.modulelist == nil then
		M.modulelist = get_modulelist()
	end

	local makeprgmodule = vim.iter(modules):find(function(val)
		return vim.iter(M.modulelist):find(val)
	end)

	if makeprgmodule ~= nil then
		local result = require("custom-plugins.makeprgdetect.modules" .. makeprgmodule)

		if result ~= nil then
			if type(result) == "string" then
				vim.opt_local.makeprg = result
			elseif type(result) == "table" then
				if result.compiler ~= nil then
					if M.compilers == nil then
						M.compilers = get_compilers()
					end
					if vim.iter(M.compilers).find(result.compiler) ~= nil then
						vim.cmd.compiler(result.compiler)
					end
				end

				if result.makeprg ~= nil then
					vim.opt_local.makeprg = result.makeprg
				end
			end
		end

		M.loaded = true
	end
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", {}, opts or {})
	M.ftlist = opts.ft
end

return M
