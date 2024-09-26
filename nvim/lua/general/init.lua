local M = {}

function M.setup(opts)
	opts = opts or {}

	local configbase = vim.fn.stdpath('config')
	if configbase == "" then
		return
	end

	for name, t in vim.fs.dir(vim.fs.joinpath(configbase,'lua', 'general')) do
		if t == "file" or t == "directory" then
			name = name:gsub("%.lua$", "")

			if name ~= "init" then
				local configopts = vim.tbl_deep_extend("keep", opts[name] or {}, { disabled = false })
				if not configopts.disabled then
					require("general." .. name).setup(configopts.config)
				end
			end
		end
	end
end

return M
