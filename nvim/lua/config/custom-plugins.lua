local map = vim.keymap.set

-- require("custom-plugins.bettermake").setup()
map("n", "<leader>bc", ":BetterMakeCompile<CR>", { desc = "Compile project", silent = true })
map("n", "<leader>bb", ":BetterMakeRecompile<CR>", { desc = "Recompile project", silent = true })

-- require("custom-plugins.projectdetect").setup()
