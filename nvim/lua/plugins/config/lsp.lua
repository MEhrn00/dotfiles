local serveropts = {
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
}

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
		require("mason-lspconfig").setup()

		local cmp = require("cmp")
		local select_behavior = { behavior = cmp.SelectBehavior.Select }
		local lspkind = require("lspkind")

		local keymaps = require("general.keymaps")

		keymaps.add({
			mode = "n",
			keys = "gl",
			action = vim.diagnostic.open_float,
			desc = "Open diagnostic window",
		})

		keymaps.add({
			mode = "n",
			keys = "ge",
			action = vim.diagnostic.goto_next,
			desc = "Go to next diagnostic",
		})

		keymaps.add({
			mode = "n",
			keys = "gE",
			action = vim.diagnostic.goto_prev,
			desc = "Go to next diagnostic",
		})

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(ev)
				local opts = { buffer = ev.buf }
				keymaps.add({
					mode = "n",
					keys = "K",
					action = vim.lsp.buf.hover,
					desc = "Display hover information",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "gd",
					action = vim.lsp.buf.definition,
					desc = "Go to definition",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "gD",
					action = vim.lsp.buf.declaration,
					desc = "Go to declaration",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "gi",
					action = vim.lsp.buf.implementation,
					desc = "List implementations",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "go",
					action = vim.lsp.buf.type_definition,
					desc = "Go to type definition",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "gr",
					action = vim.lsp.buf.references,
					desc = "List references",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "<C-k>",
					action = vim.lsp.buf.signature_help,
					desc = "Display signature help",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "crn",
					action = vim.lsp.buf.rename,
					desc = "Rename symbol",
					opts = opts,
				})

				keymaps.add({
					mode = "n",
					keys = "ga",
					action = vim.lsp.buf.code_action,
					desc = "Perform code action",
					opts = opts,
				})
			end,
		})

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

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				local opts = serveropts[server_name] or {}
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
