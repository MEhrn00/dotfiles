-- Basic plugin to emulate Emacs compile mode https://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation.html

local M = {}

local compile_commands = {}

local function run()
	local makeprg = compile_commands[vim.bo.filetype] or vim.bo.makeprg
	if makeprg == "" then
		makeprg = vim.o.makeprg
	end

	local saved = vim.bo.makeprg
	vim.bo.makeprg = makeprg

	if makeprg:find("%$%*") ~= nil then
		vim.fn.inputsave()

		vim.ui.input({
			prompt = string.format("Compile args (%s): ", makeprg),
		}, function(input)
			vim.fn.inputrestore()
			vim.cmd.redraw()

			if input == nil then
				return
			end

			if input ~= "" then
				vim.cmd.make { args = { input }, bang = true }
			else
				vim.cmd.make { bang = true }
			end
		end)
	else
		vim.cmd.make { bang = true }
	end

	vim.bo.makeprg = saved
end

function M.compile()
	local prompt = compile_commands[vim.bo.filetype] or vim.bo.makeprg
	if prompt == "" then
		prompt = vim.o.makeprg
	end

	vim.fn.inputsave()

	vim.ui.input({
		prompt = "Compile command: ",
		default = prompt,
		completion = "shellcmd",
	}, function(input)
		vim.fn.inputrestore()
		vim.cmd.redraw()

		if input == nil then
			return
		end

		compile_commands[vim.bo.filetype] = input
		run()
	end)
end

function M.recompile()
	run()
end

function M.setup(_)
	vim.api.nvim_create_user_command("CompileModeCompile", M.compile, {})
	vim.api.nvim_create_user_command("CompileModeRecompile", M.recompile, {})
end

return M
