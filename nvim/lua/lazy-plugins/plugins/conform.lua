return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofmt" },
			python = { "isort", "black" },
			cpp = { "clang-format" },
			c = { "clang-format" },
		},

		formatters = {
			rustfmt = {
				options = {
					default_edition = "2021",
				},
			},
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_fallback = true }
		end,
	},

	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function(args)
			if args.bang then
				vim.b.disable_autoformat = false
			else
				vim.g.disable_autoformat = false
			end
		end, {
			desc = "Re-enable autoformat-on-save",
			bang = true,
		})
	end,
}
