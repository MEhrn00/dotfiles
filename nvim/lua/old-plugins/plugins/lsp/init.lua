local globalopts = {
	lua_ls = {
		settings = {
			Lua = {
			},
		},
	},

	pylsp = {
	},
}

local installed_servers = {}

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig",
		"onsails/lspkind.nvim",
		"b0o/schemastore.nvim",
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({ ensure_installed = installed_servers })

		local cmp = require("cmp")
		local select_behavior = { behavior = cmp.SelectBehavior.Select }
		local lspkind = require("lspkind")
		require("lazy-plugins.plugins.lsp.keybinds").setup()

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<CR>"] = nil,
				["<C-p>"] = cmp.mapping.select_prev_item(select_behavior),
				["<C-n>"] = cmp.mapping.select_next_item(select_behavior),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-f>"] = cmp.mapping.scroll_docs(1),
				["<C-b>"] = cmp.mapping.scroll_docs(-1),
				["<C-e>"] = cmp.mapping.abort(),
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),

			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}),

			enabled = function()
				local context = require("cmp.config.context")
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end,

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					show_labelDetails = true,
				}),
			},

			experimental = {
				ghost_text = true,
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local localopts = {
			yamlls = require("yaml-companion").setup({
			}),

			jsonls = {
			},
		}
	end,
}
