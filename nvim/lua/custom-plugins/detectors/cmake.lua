local M = {
	program = "cmake",
}

function M.set_compiler(command_line)
end

function M.initial_compile_command()
	local compile_command = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build"

	local builddir = vim.fs.find(function(name, _)
		return name == "build" or name == "builddir" or name:match("^build-.*")
	end, { type = "directory" })

	if not vim.tbl_isempty(builddir) then
		compile_command = "cmake --build " .. vim.fn.fnamemodify(builddir[1], ":~:.")
	end

	return compile_command
end

function M.enabled()
	return vim.iter(vim.fs.dir(vim.fn.getcwd()))
		:any(function(name, type) return type == "file" and name == "CMakeLists.txt" end)
end

return M
