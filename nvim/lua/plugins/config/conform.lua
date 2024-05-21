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

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
