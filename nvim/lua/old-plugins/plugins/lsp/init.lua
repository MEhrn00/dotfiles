local globalopts = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					checkThirdParty = false,
					library = {
						"${3rd}/luv/library",
						unpack(vim.api.nvim_get_runtime_file("", true)),
					},
				},

				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},

	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					ruff = {
						enabled = true,
					},
					pyflakes = {
						enabled = false,
					},
				},
			},
		},
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
		"someone-stole-my-name/yaml-companion.nvim",
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
				lspconfig = {
					settings = {
						yaml = {
							valudate = true,
							schemaStore = {
								enabled = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			}),

			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
		}

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				local opts =
						vim.tbl_deep_extend("force", {}, globalopts[server_name] or {}, localopts[server_name] or {})

				opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
				require("lspconfig")[server_name].setup(opts)
			end,
		})

		local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = true,
			severity_sort = false,
		})
	end,
}
