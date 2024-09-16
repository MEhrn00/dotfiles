-- General no-dependency modules
require("general").setup({
	statusline = {
		disabled = true,
	},
	commenttoggle = {
		disabled = true,
	},
})

-- Plugin modules
require("plugins").setup()
