local keybinds = {
	{
		mode = "n",
		keys = "<leader>e",
		action = ":OverseerToggle<CR>",
		desc = "Toggle Overseer window",
	},
	{
		mode = "n",
		keys = "<leader>c",
		action = ":OverseerRun<CR>",
		desc = "Run Overseer task",
	},
	{
		mode = "n",
		keys = "<leader>b",
		action = ":OverseerRestartLast<CR>",
		desc = "Restart lat Overseer task",
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
		strategy = "terminal",
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

		vim.api.nvim_create_user_command("OverseerRestartLast", function()
			local overseer = require("overseer")
			local tasks = overseer.list_tasks({ recent_first = true })
			if vim.tbl_isempty(tasks) then
				vim.notify("No tasks found", vim.log.levels.WARN)
			else
				overseer.run_action(tasks[1], "restart")
			end
		end, {})
	end,
}
