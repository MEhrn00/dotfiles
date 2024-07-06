local M = {}

function M.has_neovide()
	return vim.g.neovide
end

function M.has_gui()
	return vim.fn.has("gui") == 1
end

function M.in_gui()
	return M.has_gui() or M.has_neovide()
end

function M.in_terminal()
	return not M.in_gui()
end

return M
