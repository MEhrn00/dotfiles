require("overseer").setup({
  strategy = "toggleterm"
})

keymap("n", "<F2>", ":OverseerRun<CR>")
