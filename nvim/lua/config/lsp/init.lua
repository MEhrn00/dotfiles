local enabled_servers = {
	"clangd",
	"rust_analyzer",
	"lua_ls",
}

vim.lsp.set_log_level("off")

for _, server in ipairs(enabled_servers or {}) do
	local ok, config = pcall(require, "config.lsp." .. server)
	if ok then
		if type(config) == "table" then
			vim.lsp.config(server, config)
		end
	end

	vim.lsp.enable(server)
end

vim.diagnostic.config({
	underline = true,
	virtual_text = {
		severity = vim.diagnostic.severity.ERROR,
		spacing = 4,
		source = "if_many",
		hl_mode = "combine",
	},
	update_in_insert = true,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		texthl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
	},
})

local providers = {
	["textDocument/completion"] = function(client, args)
		local ok, _ = pcall(require, "cmp")
		if not ok then
			vim.lsp.completion.enable(true, client.id, args.bufnr, {
				autotrigger = true,
			})
		end
	end,

	["textDocument/documentHighlight"] = function(_, args)
		vim.opt_local.updatetime = 150

		local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

		vim.api.nvim_clear_autocmds({ buffer = args.buf, group = group })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			callback = vim.lsp.buf.document_highlight,
			buffer = args.buf,
			desc = "LSP document Highlight",
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			callback = vim.lsp.buf.clear_references,
			buffer = args.buf,
			desc = "LSP clear references",
		})
	end,

	["textDocument/inlayHint"] = function(_, args)
		vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

		vim.api.nvim_create_user_command("ToggleInlayHints", function(opts)
			local filter = { bufnr = vim.api.nvim_get_current_buf() }
			if opts.bang then
				filter = {}
			end

			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
		end, {})
	end,
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("config.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		for method, cfg in pairs(providers) do
			if client:supports_method(method) then
				cfg(client, args)
			end
		end
	end,
})
