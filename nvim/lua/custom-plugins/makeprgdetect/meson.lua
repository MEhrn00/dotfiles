if vim.fn.executable("meson") == 0 then
	return
end

vim.opt_local.makeprg = "meson setup builddir"

local builddir = vim.fs.find(function(name, _)
	return name == "build" or name == "builddir" or name:match("^build-.*")
end, { type = "directory" })

if not vim.tbl_isempty(builddir) then
	vim.opt_local.makeprg = "meson compile -C " .. vim.fn.fnamemodify(builddir[1], ":~:.")
end
