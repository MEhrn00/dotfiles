vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.yml",
	callback = function()
		local fpath = vim.api.nvim_buf_get_name(0)

		if fpath:find("roles/%a[%w_]*/tasks/%a.*%.yml$") then
			vim.bo.filetype = "yaml.ansible"
			return
		end

		if fpath:find("roles/%a[%w_]*/handlers/%a.*%.yml$") then
			vim.bo.filetype = "yaml.ansible"
			return
		end

		if fpath:find("roles/%a[%w_]*/vars/%a[%w_]*%.yml$") then
			vim.bo.filetype = "yaml.ansible"
			return
		end

		if fpath:find("roles/%a[%w_]*/defaults/%a[%w_]*%.yml$") then
			vim.bo.filetype = "yaml.ansible"
			return
		end

		if fpath:find("roles/%a[%w_]*/meta/%a[%w_]*%.yml$") then
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
