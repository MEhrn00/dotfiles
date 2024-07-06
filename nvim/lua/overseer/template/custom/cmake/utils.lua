local M = {}

function M.get_cmakelists()
	return vim.fs.find("CMakeLists.txt", { upward = false, type = "file", path = vim.fn.getcwd() })[1]
end

return M
