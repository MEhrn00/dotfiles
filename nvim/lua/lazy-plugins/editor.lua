local function getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", },
		cmd = { "ConformInfo" },
		lazy = true,
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				cpp = { "clang-format" },
				c = { "clang-format" },
			},
			formatters = {
				rustfmt = {
					options = {
						default_edition = "2021",
					}
				}
			}
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 3000, lsp_fallback = true }
		end,

		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.g.disable_autoformat = true
				else
					vim.b.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat on save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function(args)
				if args.bang then
					vim.g.disable_autoformat = false
				else
					vim.b.disable_autoformat = false
				end
			end, {
				desc = "Enable autoformat on save",
				bang = true,
			})
		end,
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		cmd = "Neogit",
		opts = {
			graph_style = "unicode",
			kind = "replace",
		}
	},

	{
		'toppair/peek.nvim',
		event = { 'VeryLazy' },
		build = 'deno task --quiet build:fast',
		opts = {
			app = 'browser',
		},
		config = function(_, opts)
			local peek = require('peek')
			peek.setup(opts)

			vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
			vim.api.nvim_create_user_command("PeekClose", peek.close, {})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"someone-stole-my-name/yaml-companion.nvim",
		},
		keys = {
			{ "<C-p>", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>s", "<Cmd>Telescope live_grep<CR>", mode = "n", desc = "Search for text" },
			{
				"<leader>s",
				function()
					require("telescope.builtin").live_grep({ default_text = getVisualSelection() })
				end,
				mode = "v",
				desc = "Search for selected text",
			},
			{ "<leader>r", "<Cmd>Telescope lsp_references<CR>", desc = "LSP references" },
			{ "<leader>;", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "List buffers" },
			{ "<leader>S", "<Cmd>Telescope lsp_workspace_symbols<CR>", mode = "n", desc = "LSP workspace symbols" },
		},
		opts = {
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = "delete_buffer",
						},
						n = {
							["<c-d>"] = "delete_buffer",
						},
					}
				},
				find_files = {
					find_command = function()
						if vim.fn.executable("fd") == 1 then
							return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
						elseif vim.fn.executable("fdfind") == 1 then
							return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
						elseif vim.fn.executable("find") == 1 then
							return { "find", ".", "-type", "f" }
						elseif vim.fn.executable("where") == 1 then
							return { "where", "/r", ".", "*" }
						end
					end,
					hidden = true,
				}
			}
		},
	},

	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 20
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.5
				end
			end,

			shade_terminals = false,
			open_mapping = [[<F1>]],
			direction = "horizontal",
		},
		keys = {
			{ "<space>t", "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
			{ "<C-g>", "<Cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal" },
			{ "<C-w>k", "<Cmd>wincmd k<CR>", mode = "t", desc = "Go to window above" },
			{ "<C-w>h", "<Cmd>wincmd h<CR>", mode = "t", desc = "Go to window left" },
			{ "<C-w>l", "<Cmd>wincmd l<CR>", mode = "t", desc = "Go to window right" },
		}
	},
}
