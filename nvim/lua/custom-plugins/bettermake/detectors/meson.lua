local M = {
	program = "meson",
}

function M.set_compiler(command_line)
end

function M.initial_compile_command()
	local compile_command = "meson setup builddir"

	local builddir = vim.fs.find(function(name, _)
		return name == "build" or name == "builddir" or name:match("^build-.*")
	end, { type = "directory" })

	if not vim.tbl_isempty(builddir) then
		compile_command = "meson compile -C " .. vim.fn.fnamemodify(builddir[1], ":~:.")
	end

	return compile_command
end

function M.enabled()
	return vim.iter(vim.fs.dir(vim.fn.getcwd()))
			:any(function(name, type) return type == "file" and name == "meson.build" end)
end

return M
