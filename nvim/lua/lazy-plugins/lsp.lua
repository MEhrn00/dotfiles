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
							return not context.in_treesitter_capture("comment")
								and not context.in_syntax_group("Comment")
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
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig",
			"b0o/schemastore.nvim",
		},

		opts = function()
			local schemastore = require("schemastore")
			return {
				servers = {
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

					rust_analyzer = {
						settings = {
							["rust-analyzer"] = {
								check = {
									command = "clippy",
								},
								lens = {
									enable = true,
								},
								semanticHighlighting = {
									operator = {
										enable = true,
										specialization = {
											enable = true,
										},
									},
									punctuation = {
										enable = true,
										separate = {
											macro = {
												bang = true,
											},
										},
										specialization = {
											enable = true,
										},
									},
								},
								completion = {
									fullFunctionSignatures = {
										enable = true,
									},
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

					yamlls = require("yaml-companion").setup({
						lspconfig = {
							settings = {
								yaml = {
									valudate = true,
									schemaStore = {
										enabled = false,
										url = "",
									},
									schemas = schemastore.yaml.schemas(),
								},
							},
						},
					}),

					jsonls = {
						settings = {
							json = {
								schemas = schemastore.json.schemas(),
								validate = { enable = true },
							},
						},
					},
				},

				diagnostics = {
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
				},

				inlay_hints = {
					enabled = true,
					exclude = { "rust_analyzer", "java_language_server", "clangd" },
				},

				codelens = {
					enabled = true,
					exclude = { "java_language_server", "clangd", "rust_analyzer" },
				},

				document_highlight = {
					enabled = true,
					exclude = { "java_language_server" },
				},

				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},

				keys = {
					{ "n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", silent = true } },
					{ "n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", silent = true } },
					{ "n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", silent = true } },
					{ "n", "go", vim.lsp.buf.type_definition, { desc = "Go to type definition", silent = true } },
					{ "n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Display signature help", silent = true } },
					{ "n", "crn", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true } },
					{ "n", "ga", vim.lsp.buf.code_action, { desc = "Select code action", silent = true } },
				},

				setup = {},
			}
		end,

		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup()

			vim.api.nvim_create_user_command("LspSetqflist", function()
				vim.diagnostic.setqflist({ open = false })
			end, {})
			vim.keymap.set("n", "<leader>Q", function()
				local qfwin = vim.fn.getqflist({ winid = 1 }).winid
				if qfwin > 0 then
					vim.api.nvim_win_close(qfwin, false)
				end

				vim.diagnostic.setqflist({ open = false })
				vim.cmd("botright copen 15")
			end, { desc = "Send LSP diagnostics to quickfix list", silent = true })

			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities(),
				opts.capabilities or {}
			)

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local server_opts = vim.tbl_deep_extend(
						"force",
						{ capabilities = vim.deepcopy(capabilities) },
						opts.servers[server_name] or {}
					)

					if server_opts.enabled == false then
						return
					end

					require("lspconfig")[server_name].setup(server_opts)
				end,
			})

			vim.diagnostic.config(opts.diagnostics)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local map = vim.keymap.set
					for _, keybind in ipairs(opts.keys) do
						map(
							keybind[1],
							keybind[2],
							keybind[3],
							vim.tbl_deep_extend("keep", { buffer = args.buf }, keybind[4] or {})
						)
					end

					vim.opt_local.updatetime = 500

					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client ~= nil then
						if opts.document_highlight.enabled then
							if
								not vim.iter(opts.document_highlight.exclude or {}):any(function(v)
									return v == client.name
								end)
							then
								if client.server_capabilities.documentHighlightProvider then
									vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

									vim.api.nvim_clear_autocmds({ buffer = args.buf, group = "lsp_document_highlight" })
									vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
										callback = vim.lsp.buf.document_highlight,
										buffer = args.buf,
										group = "lsp_document_highlight",
										desc = "Document Highlight",
									})

									vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
										callback = vim.lsp.buf.clear_references,
										buffer = args.buf,
										group = "lsp_document_highlight",
										desc = "Clear All the References",
									})
								end
							end
						end

						if opts.inlay_hints.enabled then
							if
								not vim.iter(opts.inlay_hints.exclude or {}):any(function(v)
									return v == client.name
								end)
							then
								if client.server_capabilities.inlayHintProvider then
									vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
								end
							end
						end

						if opts.codelens.enabled then
							if
								not vim.iter(opts.codelens.exclude or {}):any(function(v)
									return v == client.name
								end)
							then
								if client.server_capabilities.codeLensProvider then
									vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
										buffer = args.buf,
										callback = vim.lsp.codelens.refresh,
									})
								end
							end
						end
					end
				end,
			})
		end,
	},
}
