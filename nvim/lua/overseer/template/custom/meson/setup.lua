local mesonutils = require("overseer.template.custom.meson.utils")

return {
	name = "meson setup",
	builder = function(_)
		local mesonbuild = assert(mesonutils.get_mesonbuild())

		return {
			cmd = { "meson" },
			args = { "setup", "builddir" },
			cwd = vim.fs.dirname(mesonbuild),
			components = { "default", "on_output_quickfix" },
		}
	end,
	desc = "Setup Meson project",
	condition = {
		callback = function(_)
			if vim.fn.executable("meson") == 0 then
				return false, 'Command "meson" not found'
			end

			if not mesonutils.get_mesonbuild() then
				return false, "No meson.build file found"
			end

			return true
		end,
	},
}
