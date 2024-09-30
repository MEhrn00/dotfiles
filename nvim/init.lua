require("general").setup({
	colors = {
		disabled = true,
	},
	statusline = {
		disabled = true,
	},
	bettermake = {
		config = {
			backend = "overseer",
		},
	},
})

require("lazy-plugins").setup()
