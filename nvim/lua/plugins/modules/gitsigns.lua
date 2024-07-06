return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local keymap = require("utils.keymaps")

			keymap.add({
				mode = "n",
				keys = "<leader>hs",
				action = gitsigns.stage_hunk,
				desc = "Git stage hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hr",
				action = gitsigns.reset_hunk,
				desc = "Git reset hunk",
			})

			keymap.add({
				mode = "v",
				keys = "<leader>hs",
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
				keys = "<leader>hr",
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
				keys = "<leader>hS",
				action = gitsigns.stage_buffer,
				desc = "Git stage buffer",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hu",
				action = gitsigns.undo_stage_hunk,
				desc = "Git undo previously staged hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hR",
				action = gitsigns.reset_buffer,
				desc = "Git reset buffer",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hp",
				action = gitsigns.preview_hunk,
				desc = "Git preview hunk",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hb",
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
				keys = "<leader>hd",
				action = gitsigns.diffthis,
				desc = "Git diff file",
			})

			keymap.add({
				mode = "n",
				keys = "<leader>hD",
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
		end,
	},
}
