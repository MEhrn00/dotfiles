-- Open the quick/location lists in a full window
vim.api.nvim_create_user_command("Copew", function(opts)
	if opts.args ~= nil and opts.args:len() > 0 then
		vim.cmd("botright copen " .. opts.args)
	else
		vim.cmd("botright copen 15")
	end
end, { nargs = "*" })

vim.api.nvim_create_user_command("Lopew", function(opts)
	if opts.args ~= nil and opts.args:len() > 0 then
		vim.cmd("botright lopen " .. opts.args)
	else
		vim.cmd("botright lopen 15")
	end
end, { nargs = "*" })

vim.api.nvim_create_user_command("LspSetqflist", function()
	vim.diagnostic.setqflist({ open = false })
end, {})
