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
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable" },
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
				rust = { "rustfmt", lsp_format = "fallback" },
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

			vim.api.nvim_create_user_command("Format", function(_)
				require("conform").format()
			end, {
				desc = "Format buffer",
			})

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
			mappings = {
				commit_editor = {
					["<c-x><c-c>"] = "Submit",
					["<c-c><c-c>"] = false,
					["<c-x><c-k>"] = "Abort",
					["<c-c><c-k>"] = false,
				},
				commit_editor_I = {
					["<c-x><c-c>"] = "Submit",
					["<c-c><c-c>"] = false,
					["<c-x><c-k>"] = "Abort",
					["<c-c><c-k>"] = false,
				},
				rebase_editor = {
					["<c-x><c-c>"] = "Submit",
					["<c-c><c-c>"] = false,
					["<c-x><c-k>"] = "Abort",
					["<c-c><c-k>"] = false,
				},
				rebase_editor_I = {
					["<c-x><c-c>"] = "Submit",
					["<c-c><c-c>"] = false,
					["<c-x><c-k>"] = "Abort",
					["<c-c><c-k>"] = false,
				},
			},
		},
		keys = {
			{ "<leader>gg", "<Cmd>Neogit<CR>", desc = "Open Neogit" },
		},
		config = function(_, opts)
			require("neogit").setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nocolumn_line", { clear = false }),
				pattern = "NeogitStatus",
				callback = function(_)
					vim.opt_local.colorcolumn = "0"
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("neogit_commit_options", { clear = true }),
				pattern = "NeogitCommitMessage",
				callback = function(_)
					vim.opt_local.colorcolumn = "50,72"
					vim.opt_local.textwidth = 72
				end,
			})
		end,
	},

	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		opts = {
			app = "browser",
		},
		config = function(_, opts)
			local peek = require("peek")
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
		cmd = { "Telescope" },
		keys = {
			{ "<space>.", "<Cmd>Telescope find_files<CR>", mode = { "n", "v" }, desc = "Find files" },
			{ "<space>,", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Jump to buffer" },
			{ "<space>/", "<Cmd>Telescope live_grep<CR>", mode = "n", desc = "Grep for text" },
			{
				"<leader>/",
				function()
					require("telescope.builtin").live_grep({ default_text = getVisualSelection() })
				end,
				mode = "v",
				desc = "Grep for selected text",
			},
			{ "<leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "Find LSP references" },
			{ "<leader>fi", "<Cmd>Telescope lsp_implementations<CR>", desc = "Find LSP implementations" },
			{ "<leader>ft", "<Cmd>Telescope tags<CR>", desc = "Find tags" },
			{
				"<leader>fs",
				"<Cmd>Telescope lsp_workspace_symbols<CR>",
				mode = "n",
				desc = "Find workspace LSP symbols",
			},
			{ "<leader>gd", "<Cmd>Telescope git_bcommits<CR>", mode = "n", desc = "View git history for opened file" },
			{ "<leader>gb", "<Cmd>Telescope git_branches<CR>", mode = "n", desc = "View git branches" },
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
					},
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
				},
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 20
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.5
				end
			end,

			shade_terminals = false,
			direction = "horizontal",
		},
		keys = {
			{ "<space>ot", "<Cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },
			{ "<C-j>", "<Cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal" },
		},
	},
}
