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
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig",
			"b0o/schemastore.nvim",
		},

		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
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
				}),

				enabled = function()
					local context = require("cmp.config.context")
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end,

				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},

				experimental = {
					ghost_text = true,
				}

			})

			local servers = {
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
						}
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
					local opts = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
					opts.capabilities = vim.tbl_deep_extend("force", {},
						require("cmp_nvim_lsp").default_capabilities(),
						opts.capabilities or {})

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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local map = vim.keymap.set
					map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", silent = true, buffer = event.buf })
					map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", silent = true, buffer = event.buf })
					map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", silent = true, buffer = event.buf })
					map("n", "go", vim.lsp.buf.type_definition, { desc = "Go to type definition", silent = true, buffer = event.buf })
					map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Display signature help", silent = true, buffer = event.buf })
					map("n", "crn", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true, buffer = event.buf })
					map("n", "ga", vim.lsp.buf.code_action, { desc = "Select code action", silent = true, buffer = event.buf })
				end,
			})
		end,
	},
}
