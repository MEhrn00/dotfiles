return {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
					path ~= vim.fn.stdpath('config')
					and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				path = {
					"?.lua",
					"?/init.lua",
					-- Add luarocks
					vim.fn.expand("~/.luarocks/share/lua/5.4/?.lua"),
					vim.fn.expand("~/.luarocks/share/lua/5.4/?/init.lua"),
					"/usr/share/lua/5.4/?.lua",
					"/usr/share/lua/5.4/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.expand("~/.luarocks/share/lua/5.4"),
					"/usr/share/lua/5.4",
				},
			}
		})
	end,
	settings = {
		Lua = {}
	}
}
