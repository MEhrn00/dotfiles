require("config.options")
require("config.cmds")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
-- require("config.statusline")

if vim.fn.has("gui") == 1 or vim.fn.has("gui_running") == 1 or vim.g.neovide ~= nil then
	require("config.gui")
end

if vim.g.vscode then
	require("config.vscode")
else
	require("config.lazy")
end

require("config.select")

if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
	require("config.windows")
end
