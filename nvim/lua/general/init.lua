local M = {}

function M.setup(opts)
	opts = opts or {}

	local configbase = vim.fn.stdpath('config')
	if configbase == "" then
		return
	end

	for name, t in vim.fs.dir(configbase .. "/lua/general/modules") do
		if t == "file" or t == "directory" then
			name = name:gsub("%.lua$", "")

			local configopts = vim.tbl_deep_extend("keep", opts[name] or {}, { disabled = false })
			if not configopts.disabled then
				require("general.modules." .. name).setup(opts[opts])
			end
		end
	end
end

return M
