local M = {}

function M.setup()
	local guiutils = require("utils.gui")
	if guiutils.has_neovide() then
		vim.g.fontsize = 9
		vim.g.neovide_remember_window_size = "v:true"
		vim.g.neovide_cursor_animation_length = 0
	end
end

return M
