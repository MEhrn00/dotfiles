-- "#a26e9d" -> "#569cd6"
-- "#c586c0" -> "#9cdcfe"

local colorgroups = {
	["#569cd6"] = {
		NeogitSectionHeader = {
			bold = true,
		},
		NeogitChangeRenamed = {
			bold = true,
			italic = true,
		},
		NeogitChangeModified = {
			bold = true,
			italic = true,
		},
		NeogitUnpulledFrom = {
			bold = true,
		},
		NeogitUnpushedTo = {
			bold = true,
		},
		NeogitUnmergedInto = {
			bold = true,
		},
	},

	["#9cdcfe"] = {
		NeogitPopupSwitchKey = {},
		NeogitPopupActionKey = {},
		NeogitBranch = {
			bold = true,
		},
		NeogitTagName = {},
		NeogitBranchHead = {
			bold = true,
			underline = true,
		},
		NeogitFilePath = {
			italic = true,
		},
		NeogitPopupConfigKey = {},
		NeogitPopupOptionKey = {},
	},
}

local highlights = {}

return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},

	opts = {
		graph_style = "unicode",
		kind = "replace",
	},

	config = function(_, opts)
		require("neogit").setup(opts)

		for fg, groups in pairs(colorgroups) do
			for group, groupopts in pairs(groups) do
				if groupopts ~= nil then
					local coloropts = vim.tbl_deep_extend("force", { fg = fg }, groupopts)
					vim.api.nvim_set_hl(0, group, coloropts)
				end
			end
		end

		for group, value in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, value)
		end
	end,
}
