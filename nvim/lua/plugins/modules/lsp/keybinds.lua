local M = {}

local general_keybinds = {}

local lsp_keybinds = {
	{
		mode = "n",
		keys = "gd",
		action = vim.lsp.buf.definition,
		desc = "Go to definition",
	},
	{
		mode = "n",
		keys = "gD",
		action = vim.lsp.buf.declaration,
		desc = "Go to declaration",
	},
	{
		mode = "n",
		keys = "gi",
		action = vim.lsp.buf.implementation,
		desc = "Go to implementation",
	},
	{
		mode = "n",
		keys = "go",
		action = vim.lsp.buf.type_definition,
		desc = "Go to type definition",
	},
	{
		mode = "n",
		keys = "gr",
		action = vim.lsp.buf.references,
		desc = "List references",
	},
	{
		mode = "n",
		keys = "<C-k>",
		action = vim.lsp.buf.signature_help,
		desc = "Display signature help",
	},
	{
		mode = "n",
		keys = "crn",
		action = vim.lsp.buf.rename,
		desc = "Rename symbol",
	},
	{
		mode = "n",
		keys = "ga",
		action = vim.lsp.buf.code_action,
		desc = "Perform code action",
	},
}

local lang_keybinds = {
	clangd = {
		{
			mode = "n",
			keys = "gh",
			action = ":ClangdSwitchSourceHeader<CR>",
			desc = "Switch between header and source file",
		},
	},
}

function M.setup()
	local keymaps = require("utils.keymaps")
	keymaps.apply(general_keybinds)

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			local opts = { buffer = ev.buf }

			for _, k in ipairs(lsp_keybinds) do
				k.opts = vim.tbl_deep_extend("keep", opts, k.opts or {})
				keymaps.add(k)
			end

			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and lang_keybinds[client.name] then
				for _, k in ipairs(lang_keybinds[client.name]) do
					k.opts = vim.tbl_deep_extend("keep", opts, k.opts or {})
					keymaps.add(k)
				end
			end
		end,
	})
end

return M
