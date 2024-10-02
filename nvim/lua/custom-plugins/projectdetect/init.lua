local M = {}

local modules = {
	"cmake",
	"meson",
}

local function get_compilers()
	return {}
end

function M.detect_command(compile_command)
	-- TODO
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
