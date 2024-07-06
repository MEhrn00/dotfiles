local cmakeutils = require("overseer.template.custom.cmake.utils")

return {
	name = "cmake configure",
	builder = function(_)
		local cmakelists = assert(cmakeutils.get_cmakelists())

		return {
			cmd = { "cmake" },
			args = { "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=true", "." },
			cwd = vim.fs.dirname(cmakelists),
			components = { "default", "on_output_quickfix" },
		}
	end,
	desc = "Configure CMake project",
	condition = {
		callback = function(_)
			if vim.fn.executable("cmake") == 0 then
				return false, 'Command "cmake" not found'
			end

			if not cmakeutils.get_cmakelists() then
				return false, "No CMakeLists.txt file found"
			end

			return true
		end,
	},
}
