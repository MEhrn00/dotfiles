return {
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = true,
	},

	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		opts = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")
			return {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<CR>"] = nil,
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-f>"] = cmp.mapping.scroll_docs(1),
					["<C-b>"] = cmp.mapping.scroll_docs(-1),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
				}),

				enabled = function()
					local context = require("cmp.config.context")
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end,

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},

				experimental = {
					ghost_text = true,
				},
			}
		end,
	},

	{
		"williamboman/mason.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig", import = "lazy-plugins.lsp" },
		},
		config = true,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig", import = "lazy-plugins.lsp" },
			{ "williamboman/mason.nvim", import = "lazy-plugins.lsp" },
		},
		opts = {
			automatic_enable = {
				exclude = {
					"rust_analyzer",
				},
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "hrsh7th/nvim-cmp", import = "lazy-plugins.lsp" },
		},
		config = false,
	},
}
