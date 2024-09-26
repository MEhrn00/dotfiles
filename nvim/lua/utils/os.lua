local M = {}

function M.is_win32()
	return vim.fn.has("win32") == 1
end

function M.is_unix()
	return vim.fn.has("unix") == 1
end

function M.homedir()
	if M.is_unix() then
		return vim.env.HOME
	elseif M.is_win32() then
		return vim.env.USERPROFILE
	end
end

function M.pathsep()
	if M.is_win32() then
		return '\\'
	end
	return '/'
end

return M
