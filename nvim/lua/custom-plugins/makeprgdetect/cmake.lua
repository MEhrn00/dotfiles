if vim.fn.executable("cmake") == 0 then
	return
end

vim.opt_local.makeprg = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build"

local builddir = vim.fs.find(function(name, _)
	return name == "build" or name == "builddir" or name:match("^build-.*")
end, { type = "directory" })

if not vim.tbl_isempty(builddir) then
	vim.opt_local.makeprg = "cmake --build " .. vim.fn.fnamemodify(builddir[1], ":~:.")
	return
end
