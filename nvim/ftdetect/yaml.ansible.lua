vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yml", "*.yaml" },
	callback = function()
		local fpath = vim.api.nvim_buf_get_name(0)

		local patterns = {
			"%a[%w_]*/tasks/%a.*%.ya?ml$",
			"%a[%w_]*/handlers/%a.*%.ya?ml$",
			"%a[%w_]*/vars/%a[%w_]*%.ya?ml$",
			"%a[%w_]*/defaults/%a[%w_]*%.ya?ml$",
			"%a[%w_]*/meta/%a[%w_]*%.ya?ml$",
		}

		local it = vim.iter(patterns)
		if fpath:sub(1, ("roles/"):len()) == "roles/" then
			it:map(function(v)
				return "roles/" .. v
			end)
		end

		local matched = it:any(function(pattern)
			return fpath:find(pattern) ~= nil
		end)

		if matched then
			vim.bo.filetype = "yaml.ansible"
			return
		end

		local fdir = string.gsub(vim.api.nvim_buf_get_name(0), "/[^/\\]+$", "")

		local fp = io.open(fdir .. "/ansible.cfg", "r")
		if fp ~= nil then
			vim.bo.filetype = "yaml.ansible"
			fp:close()
		end
	end,
})
