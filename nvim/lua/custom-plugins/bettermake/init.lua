-- Basic plugin to emulate Emacs compile/recompile mode using makeprg https://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation.html

-- backends:
-- make
-- neomake
-- overseer

local M = {}

local defaults = {
	backend = "make",
}

local detectors = {
	require("custom-plugins.bettermake.detectors.cmake"),
	require("custom-plugins.bettermake.detectors.meson"),
}

local compile_command = nil

local backend_handlers = {
	make = function(_)
		vim.cmd.make()
	end,
	neomake = function(_)
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

local handler = backend_handlers.make

local function do_compile(recompile)
	local saved_makeprg = vim.opt_local.makeprg

	local compile_prog = ""
	if compile_command ~= "" then
		local tokens = {}
		for token in compile_command:gmatch("[^%s]+") do
			table.insert(tokens, token)
		end

		compile_prog = vim.fn.fnamemodify(tokens[1], ":t")
	end

	local detector = vim.iter(detectors):find(function(v)
		return vim.fn.executable(v.program) == 1 and v.enabled() and compile_prog == v.program
	end)

	if detector ~= nil then
		detector.set_compiler(compile_command)
	end

	vim.opt_local.makeprg = compile_command
	handler(recompile)
	vim.opt_local.makeprg = saved_makeprg
end

function M.recompile()
	if compile_command == nil then
		M.compile()
	else
		do_compile(true)
	end
end

function M.compile()
	local prompt = compile_command

	if prompt == nil then
		local detector = vim.iter(detectors):find(function(v)
			return vim.fn.executable(v.program) == 1 and v.enabled()
		end)

		if detector ~= nil then
			prompt = detector.initial_compile_command()
		else
			prompt = vim.fn.expandcmd(vim.opt_local.makeprg:get())
		end
	end

	vim.ui.input({
		prompt = "Compile command: ",
		default = prompt,
		completion = "shellcmd",
		cancelreturn = "false",
	}, function(input)
		if input == nil or (input ~= nil and input == "false") then
			return
		end

		compile_command = input
		vim.cmd.redraw()
		do_compile(false)
	end)
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

	handler = backend_handlers[opts.backend] or backend_handlers[defaults.backend]

	vim.api.nvim_create_user_command("BetterMakeCompile", M.compile, {})
	vim.api.nvim_create_user_command("BetterMakeRecompile", M.recompile, {})
end

return M
