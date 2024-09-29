local function getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"someone-stole-my-name/yaml-companion.nvim",
	},

	opts = {
		pickers = {
			buffers = {
				mappings = {
					i = {
						["<c-d>"] = "delete_buffer",
					},
					n = {
						["<c-d>"] = "delete_buffer",
					},
				},
			},
		},
	},

	config = function(_, opts)
		require("telescope").setup(opts)
		local builtin = require("telescope.builtin")

		require("telescope").load_extension("yaml_schema")

		require("utils.keymaps").apply({
			{
				mode = "n",
				keys = "<c-p>",
				action = builtin.find_files,
				desc = "Find files",
			},
			{
				mode = "n",
				keys = "<leader>s",
				action = builtin.live_grep,
				desc = "Search for text",
			},
			{
				mode = "v",
				keys = "<leader>s",
				action = function()
					local selectedtext = getVisualSelection()
					builtin.live_grep({ default_text = selectedtext })
				end,
				desc = "Search for selected word",
			},
			{
				mode = "n",
				keys = "<leader>r",
				action = builtin.lsp_references,
				desc = "LSP references",
			},
			{
				mode = "n",
				keys = "<leader>;",
				action = builtin.buffers,
				desc = "List currently open buffers",
			},
			{
				mode = "n",
				keys = "<leader>S",
				action = builtin.lsp_workspace_symbols,
				desc = "LSP workspace symbols",
			},
			{
				mode = "v",
				keys = "<leader>S",
				action = function()
					local selectedtext = getVisualSelection()
					builtin.live_grep({ default_text = selectedtext })
				end,
				desc = "Search for selected symbol",
			},
		})
	end,
}
