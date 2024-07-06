local colors = {
	white = "#ffffff",
	darkgray = "#262626",
	lightgray = "#373737",
	dimgray = "#666666",
	darkblue = "#0a7aca",
	yellow = "#ffaf00",
	red = "#f44747",
	gitgreen = "#95ffa4",
	turquoise = "#4ec9b0",
}

local theme = {
	normal = {
		a = { bg = colors.darkblue, fg = colors.white, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.darkblue },
		c = { bg = colors.darkgray, fg = colors.white },
	},

	insert = {
		a = { bg = colors.turquoise, fg = colors.darkgray, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.turquoise },
		c = { bg = colors.darkgray, fg = colors.white },
	},

	visual = {
		a = { bg = colors.yellow, fg = colors.darkgray, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.yellow },
	},

	replace = {
		a = { bg = colors.red, fg = colors.darkgray, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.red },
		c = { bg = colors.darkgray, fg = colors.white },
	},

	command = {
		a = { bg = colors.white, fg = colors.darkgray, gui = "bold" },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.white },
	},

	inactive = {
		a = { bg = colors.darkgray, fg = colors.white, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.dimgray },
		c = { bg = colors.darkgray, fg = colors.dimgray },
	},
}

local function qflist()
	local info_hl = "%#lualine_b_diagnostics_info_normal#"
	local warn_hl = "%#lualine_b_diagnostics_warn_normal#"
	local error_hl = "%#lualine_b_diagnostics_error_normal#"
	local hl_reset = "%#lualine_b_normal#"

	local icons = require("lualine.components.diagnostics.config").symbols.icons
	local qflist_results = vim.fn.getqflist({ id = 0, items = 0, size = 0 })

	if qflist_results.size == 0 then
		return ""
	end

	local result = { I = 0, W = 0, E = 0 }
	for _, item in pairs(qflist_results.items) do
		result[item.type] = result[item.type] + 1
	end

	local info = ""
	if result["I"] > 0 then
		info = info_hl .. icons.info .. result["I"] .. hl_reset

		if result["W"] > 0 or result["E"] > 0 then
			info = info .. " "
		end
	end

	local warn = ""
	if result["W"] > 0 then
		warn = warn_hl .. icons.warn .. result["W"] .. hl_reset

		if result["E"] > 0 then
			warn = warn .. " "
		end
	end

	local error = ""
	if result["E"] > 0 then
		error = error_hl .. icons.error .. result["E"] .. hl_reset
	end

	return string.format("%s%s%s", info, warn, error)
end

local function get_schema()
	local schema = require("yaml-companion").get_buf_schema(0)
	if schema.result[1].name == "none" then
		return ""
	end
	return schema.result[1].name
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"omeone-stole-my-name/yaml-companion.nvim",
		{ "stevearc/overseer.nvim", import = "plugins.modules.overseer" },
	},
	lazy = false,
	opts = {
		options = {
			icons_enabled = true,
			theme = theme,
		},

		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "fileformat", "filetype", get_schema, "overseer" },
			lualine_y = {
				{
					qflist,
					icon = "🔨",
				},
				"progress",
			},
			lualine_z = { "location" },
		},
	},

	config = function(_, opts)
		require("lualine").setup(opts)
	end,
}
