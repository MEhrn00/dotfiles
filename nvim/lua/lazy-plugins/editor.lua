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
		cmd = { "ConformInfo", "Format" },
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
		},

		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("Format", function(_)
				require("conform").format()
			end, {
				desc = "Format buffer",
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
		},
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
			{ "<leader>ff", "<Cmd>Telescope find_files<CR>", mode = { "n", "v" }, desc = "Find files" },
			{ "<leader>fg", "<Cmd>Telescope live_grep<CR>", mode = "n", desc = "Grep for text" },
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep({ default_text = getVisualSelection() })
				end,
				mode = "v",
				desc = "Grep for selected text",
			},
			{ "<leader>fr", "<Cmd>Telescope lsp_references<CR>", desc = "Find LSP references" },
			{ "<leader>fd", "<Cmd>Telescope lsp_definitions<CR>", desc = "Find LSP definitions" },
			{ "<leader>fi", "<Cmd>Telescope lsp_implementations<CR>", desc = "Find LSP implementations" },
			{ "<leader>;", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "List buffers" },
			{ "<leader>fs", "<Cmd>Telescope lsp_workspace_symbols<CR>", mode = "n", desc = "Find workspace LSP symbols" },
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
