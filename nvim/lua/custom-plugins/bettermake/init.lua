-- Basic plugin to emulate Emacs compile/recompile mode using makeprg https://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation.html

-- backends:
-- make
-- neomake

local M = {}

local defaults = {
	backend = "make",
}

local backend_handlers = {
	make = function(compile_command, project)
		local varopt = "opt_local"
		if project then
			varopt = "opt"
		end

		local saved_makeprg = vim[varopt].makeprg
		vim[varopt].makeprg = compile_command
		vim.cmd.make()
		vim[varopt].makeprg = saved_makeprg
	end,
	neomake = function(compile_command, _) end,
}

local function input_wrap(prompt, default)
	return vim.ui.input({
		prompt = prompt,
		default = default,
		completion = "shellcmd",
		cancelreturn = "false",
	}, function(input)
		if input == nil or (input ~= nil and input == "false") then
			print("Cancelled")
			return
		end

		vim.cmd.redraw()
		return input
	end)
end

local function get_compile_command()
	return input_wrap("Compile command: ", vim.g.bettermake_compile_command or vim.opt_local.makeprg:get())
end

local function get_project_compile_command()
	return input_wrap("Project compile command: ", vim.g.bettermake_project_compile_command or vim.opt.makeprg:get())
end

function M.recompile()
	local compile_command = vim.g.bettermake_compile_command
	if compile_command == nil then
		compile_command = get_compile_command()
	end

	vim.g.bettermake_handler(compile_command, false)
end

function M.recompile_project()
	local compile_command = vim.g.bettermake_project_compile_command
	if compile_command == nil then
		compile_command = get_project_compile_command()
	end

	vim.g.bettermake_handler(compile_command, true)
end

function M.compile()
	local compile_command = get_compile_command()
	vim.g.bettermake_handler(compile_command, false)
end

function M.compile_project()
	local compile_command = get_project_compile_command()
	vim.g.bettermake_handler(compile_command, true)
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

	vim.g.bettermake_handler = backend_handlers[opts.backend] or backend_handlers[defaults.backend]

	vim.api.nvim_create_user_command("BetterMakeCompile", function(args)
		if args.bang then
			M.compile_project()
		else
			M.compile()
		end
	end, {
		bang = true,
	})

	vim.api.nvim_create_user_command("BetterMakeRecompile", function(args)
		if args.bang then
			M.recompile_project()
		else
			M.recompile()
		end
	end, {
		bang = true,
	})

	vim.api.nvim_create_user_command("BetterMakeTest", function(args)
		vim.fn["neomake#Make"]({ file_mode = 0 })
		--vim.cmd.copen()
	end, {
		bang = true,
	})
end

return M
