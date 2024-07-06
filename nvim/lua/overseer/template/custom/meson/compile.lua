local mesonutils = require("overseer.template.custom.meson.utils")
local overseer = require("overseer")

return {
	name = "meson compile",
	builder = function(_)
		local mesonbuild = assert(mesonutils.get_mesonbuild())

		return {
			cmd = { "meson" },
			args = { "compile", "-C", "builddir" },
			cwd = vim.fs.dirname(mesonbuild),
			components = { "default", "on_output_quickfix" },
		}
	end,
	desc = "Build Meson project",
	tags = { overseer.TAG.BUILD },
	condition = {
		callback = function(_)
			local mesonbuild = mesonutils.get_mesonbuild()

			if vim.fn.executable("meson") == 0 then
				return false, 'Command "meson" not found'
			end

			if not mesonbuild then
				return false, "No meson.build file found"
			end

			if vim.fn.isdirectory(vim.fs.dirname(mesonbuild) .. "/builddir") ~= 1 then
				return false, "Meson build directory not configured"
			end

			return true
		end,
	},
}
