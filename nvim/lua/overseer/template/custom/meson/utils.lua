local M = {}

function M.get_mesonbuild()
	return vim.fs.find("meson.build", { upward = false, type = "file", path = vim.fn.getcwd() })[1]
end

return M
