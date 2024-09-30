-- Basic plugin to emulate Emacs compile/recompile mode using makeprg https://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation.html

-- backends:
-- make
-- neomake
-- overseer

local M = {}

local defaults = {
	backend = "make",
}

local backend_handlers = {
	make = function()
		vim.cmd.make()
	end,
	neomake = function()
		vim.fn["neomake#Make"]({ file_mode = 0 })
	end,
	overseer = function(recompile)
		local overseer = require("overseer")

		if recompile then
			local tasks = overseer.list_tasks({ recent_first = true })
			if vim.tbl_isempty(tasks) then
				vim.notify("No tasks found", vim.log.levels.WARN)
			else
				overseer.run_action(tasks[1], "restart")
			end
		else
			local task = overseer.new_task({
				cmd = vim.fn.expandcmd(vim.opt_local.makeprg:get()),
				components = {
					{
						"on_output_quickfix",
						open = false,
						open_height = 10,
					},
					"default",
				},
			})

			task:start()
		end
	end,
}

local function do_compile(compile_command, handler, recompile)
	local saved_makeprg = vim.opt_local.makeprg
	vim.opt_local.makeprg = compile_command
	handler(recompile)
	vim.opt_local.makeprg = saved_makeprg
end

function M.recompile()
	if M.compile_command == nil then
		M.compile()
	else
		do_compile(M.compile_command, M.handler, true)
	end
end

function M.compile()
	vim.ui.input({
		prompt = "Compile command: ",
		default = M.compile_command or vim.opt_local.makeprg:get(),
		completion = "shellcmd",
		cancelreturn = "false",
	}, function(input)
		if input == nil or (input ~= nil and input == "false") then
			print("Cancelled")
			return
		end

		M.compile_command = input
		vim.cmd.redraw()
		do_compile(input, M.handler, false)
	end)
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

	M.handler = backend_handlers[opts.backend] or backend_handlers[defaults.backend]

	vim.api.nvim_create_user_command("BetterMakeCompile", M.compile, {})
	vim.api.nvim_create_user_command("BetterMakeRecompile", M.recompile, {})
end

return M
