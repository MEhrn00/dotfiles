local keybinds = {
	{
		mode = "n",
		keys = "<leader>e",
		action = ":OverseerToggle<CR>",
		desc = "Toggle Overseer window",
	},

	{
		mode = "n",
		keys = "<leader>b",
		action = ":OverseerRun<CR>",
		desc = "Run Overseer task",
	},
}

return {
	"stevearc/overseer.nvim",
	dependencies = {
		{
			"akinsho/toggleterm.nvim",
			import = "plugins.modules.toggleterm",
		},
	},

	opts = {
		templates = {
			"builtin",
			"custom.cmake",
			"custom.meson",
		},
	},

	config = function(_, opts)
		require("overseer").setup(opts)
		local keymaps = require("utils.keymaps")
		keymaps.apply(keybinds)

		vim.api.nvim_create_user_command("Make", function(params)
			-- Insert args at the '$*' in the makeprg
			local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
			if num_subs == 0 then
				cmd = cmd .. " " .. params.args
			end
			local task = require("overseer").new_task({
				cmd = vim.fn.expandcmd(cmd),
				components = {
					{ "on_output_quickfix", open = not params.bang, open_height = 8 },
					"default",
				},
			})
			task:start()
		end, {
			desc = "Run makeprg as an Overseer task",
			nargs = "*",
			bang = true,
		})
	end,
}
