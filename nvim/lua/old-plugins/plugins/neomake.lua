return {
	"neomake/neomake",
	opts = {
		global = {
			open_list = 2,
		},
	},
	config = function(_, opts)
		for key, val in pairs(opts.global or {}) do
			vim.g["neomake_" .. key] = val
		end

		for key, val in pairs(opts.buffer or {}) do
			vim.b["neomake_" .. key] = val
		end
	end,
}
