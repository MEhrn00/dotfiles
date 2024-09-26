return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local keymap = require("utils.keymaps")

			keymap.add({
				mode = "n",
				keys = "<leader>gs",
				action = gitsigns.stage_hunk,
				desc = "Git stage hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gr",
				action = gitsigns.reset_hunk,
				desc = "Git reset hunk",
			})

			keymap.add({
				mode = "v",
				keys = "<leader>gs",
				action = function()
					gitsigns.stage_hunk({
						vim.fn.line("."),
						vim.fn.line("v"),
					})
				end,
				desc = "Git stage selected hunk",
			})

			keymap.add({
				mode = "v",
				keys = "<leader>gr",
				action = function()
					gitsigns.reset_hunk({
						vim.fn.line("."),
						vim.fn.line("v"),
					})
				end,
				desc = "Git reset selected hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gS",
				action = gitsigns.stage_buffer,
				desc = "Git stage buffer",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gu",
				action = gitsigns.undo_stage_hunk,
				desc = "Git undo previously staged hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gR",
				action = gitsigns.reset_buffer,
				desc = "Git reset buffer",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gg",
				action = gitsigns.preview_hunk,
				desc = "Git preview hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gb",
				action = function()
					gitsigns.blame_line({ full = true })
				end,
				desc = "Git view full line blame",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>tb",
				action = gitsigns.toggle_current_line_blame,
				desc = "Git toggle current line blame",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gd",
				action = gitsigns.diffthis,
				desc = "Git diff file",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>gD",
				action = function()
					gitsigns.diffthis("~")
				end,
				desc = "Git diff to HEAD",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>td",
				action = gitsigns.toggle_deleted,
				desc = "Git toggle deleted",
			})

			keymap.add({
				mode = "n",
				keys = "]g",
				action = function()
					gitsigns.nav_hunk("next")
				end,
				desc = "Git go to next hunk",
			})

			keymap.add({
				mode = "n",
				keys = "[g",
				action = function()
					gitsigns.nav_hunk("prev")
				end,
				desc = "Git go to previous hunk",
			})

			keymap.add({
				mode = "n",
				keys = "[G",
				action = function()
					gitsigns.nav_hunk("first")
				end,
				desc = "Git go to first hunk",
			})

			keymap.add({
				mode = "n",
				keys = "]G",
				action = function()
					gitsigns.nav_hunk("last")
				end,
				desc = "Git go to last hunk",
			})
		end,
	},
}
