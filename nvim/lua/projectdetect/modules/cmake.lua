local M = {
	program = "cmake",
}

function M.detect_compiler(cmdline) end

function M.detect_makeprg()
	if vim.fn.executable("cmake") == 0 then
		return nil
	end

	local makeprg = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build"

	local builddir = vim.fs.find(function(name, _)
		return name == "build" or name == "builddir" or name:match("^build-.*")
	end, { type = "directory" })

	local compiler = "cmake"

	if not vim.tbl_isempty(builddir) then
		makeprg = "cmake --build " .. vim.fn.fnamemodify(builddir[1], ":~:.")
	end

	return {
		makeprg = makeprg,
		compiler = compiler,
	}
end

return M
