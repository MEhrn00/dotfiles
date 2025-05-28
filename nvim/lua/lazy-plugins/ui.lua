local lualinecolors = {
	white = "#ffffff",
	darkgray = "#262626",
	lightgray = "#373737",
	dimgray = "#666666",
	darkblue = "#0a7aca",
	yellow = "#ffaf00",
	red = "#f44747",
	gitgreen = "#95ffa4",
	turquoise = "#4ec9b0",
}

return {
	-- Color scheme
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("vscode")

			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "NvimDarkGray4" })
			vim.api.nvim_set_hl(0, "netrwMarkFile", {
				italic = true,
				undercurl = true,
				bg = "NvimDarkGrey3",
			})
		end,
	},

	-- Open buffer navigation bar
	{
		"romgrk/barbar.nvim",
		dependencies = {
			{ "lewis6991/gitsigns.nvim", import = "lazy-plugins.ui" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		lazy = false,
		keys = {
			{ "[b", "<Cmd>BufferPrevious<CR>", desc = "Go to previous buffer" },
			{ "]b", "<Cmd>BufferNext<CR>", desc = "Go to next buffer" },
			{ "<leader>d", "<Cmd>BufferClose<CR>", desc = "Delete buffer" },
			{ "<leader>p", "<Cmd>BufferPick<CR>", desc = "Select buffer" },
			{ "<leader>1", "<Cmd>BufferGoto 1<CR>", desc = "Go to buffer 1" },
			{ "<leader>2", "<Cmd>BufferGoto 2<CR>", desc = "Go to buffer 2" },
			{ "<leader>3", "<Cmd>BufferGoto 3<CR>", desc = "Go to buffer 3" },
			{ "<leader>4", "<Cmd>BufferGoto 4<CR>", desc = "Go to buffer 4" },
			{ "<leader>5", "<Cmd>BufferGoto 5<CR>", desc = "Go to buffer 5" },
			{ "<leader>6", "<Cmd>BufferGoto 6<CR>", desc = "Go to buffer 6" },
			{ "<leader>6", "<Cmd>BufferGoto 7<CR>", desc = "Go to buffer 7" },
			{ "<leader>8", "<Cmd>BufferGoto 8<CR>", desc = "Go to buffer 8" },
			{ "<leader>9", "<Cmd>BufferGoto 9<CR>", desc = "Go to buffer 9" },
			{ "<leader>0", "<Cmd>BufferLast<CR>", desc = "Go to last buffer" },
			{ "<leader>z", "<Cmd>BufferMovePrevious<CR>", desc = "Move buffer left" },
			{ "<leader>x", "<Cmd>BufferMoveNext<CR>", desc = "Move buffer right" },
		},
	},

	-- Floating vim.ui windows.
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			picker = { enabled = false },
			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },

			-- Handling of large files.
			bigfile = {
				enabled = true,
				notify = true,
				-- 1.5mb threshold
				size = 1.5 * 1024 * 1024,
				line_length = 1000,
			},

			-- Floating input window
			input = {
				enabled = true,
			},

			-- Window styles
			styles = {
				input = {
					row = 15,
					keys = {
						-- Keybinds for the input window
						["<C-c>"] = { "cancel", mode = "i" },
						["<C-f>"] = { "<Right>", mode = "i", expr = true },
						["<C-b>"] = { "<Left>", mode = "i", expr = true },
						["<C-a>"] = { "<Home>", mode = "i", expr = true },
						["<C-e>"] = { "<End>", mode = "i", expr = true },
						["<esc>f"] = { "<S-Right>", mode = "i", expr = true },
						["<esc>b"] = { "<S-Left>", mode = "i", expr = true },
						["<C-d>"] = { "<Del>", mode = "i", expr = true },
						["<C-k>"] = {
							function()
								local _, _, currentcol, _, _ = table.unpack(vim.fn.getcurpos())
								local linelen = vim.fn.getline(1):len()
								if linelen == currentcol then
									return ""
								end

								return string.rep("<Del>", linelen - currentcol + 1)
							end,
							mode = "i",
							expr = true,
						},
					},
				},
			},
		},
	},

	-- Git buffer integration. Changes in column and git operations
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
				end

				map("n", "]g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Git next hunk")

				map("n", "[g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Git previous hunk")

				map("n", "]G", function()
					gs.nav_hunk("last")
				end, "Git last hunk")
				map("n", "[G", function()
					gs.nav_hunk("first")
				end, "Git first hunk")
				map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Git stage hunk")
				map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Git reset hunk")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Git undo stage hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Git stage buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Git reset buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Git preview")
				map("n", "<leader>gtd", gs.toggle_deleted, "Git toggle deleted")
			end,
		},
	},

	-- Visual indentation lines
	{
		"lukas-reineke/indent-blankline.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		main = "ibl",
		lazy = false,
		opts = {
			indent = {
				char = "┋",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				highlight = "DiagnosticOk",
			},
		},
	},

	-- Highlight TODO-style comments
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = true },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		main = "nvim-treesitter.configs",
		opts = {
			auto_install = true,
			highlight = {
				enable = true,
			},
		},
	},

	-- Sticky code scope context at the top of the window
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		dependencies = { { "nvim-treesitter/nvim-treesitter", import = "lazy-plugins.ui" } },
		main = "treesitter-context",
		config = true,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"someone-stole-my-name/yaml-companion.nvim",
		},
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				vim.o.statusline = " "
			end
		end,
		opts = {
			options = {
				theme = {
					normal = {
						a = { bg = lualinecolors.darkblue, fg = lualinecolors.white, gui = "bold" },
						b = { bg = lualinecolors.lightgray, fg = lualinecolors.darkblue },
						c = { bg = lualinecolors.darkgray, fg = lualinecolors.white },
					},
					insert = {
						a = { bg = lualinecolors.turquoise, fg = lualinecolors.darkgray, gui = "bold" },
						b = { bg = lualinecolors.lightgray, fg = lualinecolors.turquoise },
						c = { bg = lualinecolors.darkgray, fg = lualinecolors.white },
					},
					visual = {
						a = { bg = lualinecolors.yellow, fg = lualinecolors.darkgray, gui = "bold" },
						b = { bg = lualinecolors.darkgray, fg = lualinecolors.yellow },
					},
					replace = {
						a = { bg = lualinecolors.red, fg = lualinecolors.darkgray, gui = "bold" },
						b = { bg = lualinecolors.lightgray, fg = lualinecolors.red },
						c = { bg = lualinecolors.darkgray, fg = lualinecolors.white },
					},
					command = {
						a = { bg = lualinecolors.white, fg = lualinecolors.darkgray, gui = "bold" },
						b = { bg = lualinecolors.lightgray, fg = lualinecolors.white },
						c = { bg = lualinecolors.darkgray, fg = lualinecolors.white },
					},
					inactive = {
						a = { bg = lualinecolors.darkgray, fg = lualinecolors.white, gui = "bold" },
						b = { bg = lualinecolors.darkgray, fg = lualinecolors.dimgray },
						c = { bg = lualinecolors.darkgray, fg = lualinecolors.dimgray },
					},
				},
				icons_enabled = true,
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "alpha" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					function()
						local schema = require("yaml-companion").get_buf_schema(0).result[1].name
						if schema == "none" then
							return ""
						end
						return schema
					end,
				},
				lualine_y = {
					{
						function()
							local icons = require("lualine.components.diagnostics.config").symbols.icons
							local qflist = vim.fn.getqflist({ items = 0 })
							local entries = vim.iter(qflist.items)
								:filter(function(item)
									return item.valid == 1
								end)
								:totable()

							if vim.tbl_count(entries) == 0 then
								return ""
							end

							local info = vim.tbl_count(vim.iter(entries)
								:filter(function(entry)
									return entry.type == "I" or entry.type == "i"
								end)
								:totable())

							local warnings = vim.tbl_count(vim.iter(entries)
								:filter(function(entry)
									return entry.type == "W" or entry.type == "w"
								end)
								:totable())

							local errors = vim.tbl_count(vim.iter(entries)
								:filter(function(entry)
									return entry.type == "E" or entry.type == "e"
								end)
								:totable())

							local results = ""
							if info > 0 then
								results = results
									.. "%#lualine_b_diagnostics_info_normal#"
									.. icons.info
									.. info
									.. "%#lualine_b_normal#"
								if warnings > 0 or errors > 0 then
									results = results .. " "
								end
							end

							if warnings > 0 then
								results = results
									.. "%#lualine_b_diagnostics_warn_normal#"
									.. icons.warn
									.. warnings
									.. "%#lualine_b_normal#"
								if errors > 0 then
									results = results .. " "
								end
							end

							if errors > 0 then
								results = results
									.. "%#lualine_b_diagnostics_error_normal#"
									.. icons.error
									.. errors
									.. "%#lualine_b_normal#"
							end

							return results
						end,
						icon = "🔨",
					},
					"progress",
				},
				lualine_z = { "location" },
			},
			extensions = { "quickfix", "man", "mason", "overseer", "toggleterm" },
		},
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				name = "window-picker",
				event = "VeryLazy",
				version = "2.*",
				opts = {
					hint = "floating-letter",
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
				},
			},
		},
		cmd = { "Neotree" },
		keys = {
			{ "<space>f", "<Cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
	},

	-- LSP status in the file tree
	{
		"antosha417/nvim-lsp-file-operations",
		name = "lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-neo-tree/neo-tree.nvim", import = "lazy-plugins.ui" },
		},
		main = "lsp-file-operations",
		config = true,
	},

	-- Better quickfix list window
	{
		"kevinhwang91/nvim-bqf",
		dependencies = { { "junegunn/fzf", import = "lazy-plugins.editor" } },
		opts = {
			auto_enable = true,
			filter = {
				fzf = {
					extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
				},
			},
		},
		config = function(_, opts)
			require("bqf").setup(opts)
			vim.api.nvim_set_hl(0, "BqfPreviewFloat", { bg = "#222324", force = true })
		end,
	},
}
