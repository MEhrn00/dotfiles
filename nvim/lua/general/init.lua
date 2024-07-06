local M = {}

function M.setup(opts)
	local configpath = ""

	for _, p in ipairs(vim.api.nvim_list_runtime_paths()) do
		if p:find("%.config/nvim$") then
			configpath = p
			break
		end
	end

	if configpath == "" then
		return
	end

	local modulespath = "lua/general/modules"

	local modulelist = vim.split(vim.fn.glob(configpath .. "/" .. modulespath .. "/*"), "\n", { trimempty = true })

	for _, modpath in ipairs(modulelist) do
		local modname = modpath:match("/(%a+)/?%.lua$")

		local skip = false
		local modopts = nil
		if opts ~= nil and opts[modname] ~= nil then
			if opts[modname].disabled ~= nil and opts[modname].disabled then
				skip = true
			end

			if opts[modname].opts then
				modopts = opts[modname].opts
			end
		end

		if not skip then
			if modopts ~= nil then
				require("general.modules." .. modname).setup(modopts)
			else
				require("general.modules." .. modname).setup()
			end
		end
	end

	-- require("general.modules.options").setup()
	-- require("general.modules.keymaps").setup()

	-- if vim.fn.has("win32") == 1 then
	-- 	require("general.windows").setup()
	-- elseif vim.fn.has("unix") == 1 then
	-- 	require("general.linux").setup()
	-- end

	-- if vim.g.neovide then
	-- 	require("general.neovide").setup()
	-- end

	-- if vim.g.neovide or vim.fn.has("gui") then
	-- 	require("general.gui").setup()
	-- end

	-- require("general.ctags").setup()
	-- require("general.commenttoggle").setup()
end

return M
