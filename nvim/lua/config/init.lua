require("config.options")
require("config.keymaps")
require("config.autocmds")
-- require("config.statusline")

if vim.fn.has("gui") == 1 or vim.g.neovide ~= nil then
	require("config.gui")
end

if vim.g.vscode then
	require("config.vscode")
else
	require("config.lazy")
end
