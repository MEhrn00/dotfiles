local cmakeutils = require("overseer.template.custom.cmake.utils")
local overseer = require("overseer")

return {
	name = "cmake build",
	builder = function(_)
		local cmakelists = assert(cmakeutils.get_cmakelists())

		return {
			cmd = { "cmake" },
			args = { "--build", "build" },
			cwd = vim.fs.dirname(cmakelists),
			components = { "default", "on_output_quickfix" },
		}
	end,
	desc = "Build CMake project",
	tags = { overseer.TAG.BUILD },
	condition = {
		callback = function(_)
			local cmakelists = cmakeutils.get_cmakelists()

			if vim.fn.executable("cmake") == 0 then
				return false, 'Command "cmake" not found'
			end

			if not cmakelists then
				return false, "No CMakeLists.txt file found"
			end

			if vim.fn.isdirectory(vim.fs.dirname(cmakelists) .. "/build") ~= 1 then
				return false, "CMake build directory not configured"
			end

			return true
		end,
	},
}
