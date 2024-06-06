vim.g.c_no_curly_error = 1

local keymaps = require("general.keymaps")

local fp = io.open(vim.fn.getcwd() .. "/CMakeLists.txt", "r")
if fp ~= nil then
	keymaps.add({
		mode = "n",
		keys = "<leader>b",
		action = ":CMakeBuild<CR>",
		desc = "Build CMake project",
		opts = {
			buffer = true,
		},
	})

	fp:close()
end
