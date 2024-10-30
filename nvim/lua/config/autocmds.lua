vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("quick_close", { clear = true }),
	pattern = {
		"qf",
		"toggleterm",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<Cmd>close<CR>", {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer",
		})
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("terminal_numbers", { clear = true }),
	callback = function(event)
		local map = vim.keymap.set

		vim.opt_local.number = false
		map("n", "<leader>d", "<Cmd>bd!<CR>", { desc = "Delete buffer", silent = true, buffer = event.buf })
	end,
})
