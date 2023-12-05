require("neo-tree").setup({
  default_component_configs = {
    git_status = {
      symbols = {
        untracked = "U",
        ignored = "I",
        unstaged = "M",
        staged = "S",
        conflict = "C"
      }
    }
  },

  source_selector = {
    winbar = true,

    sources = {
      { source = 'filesystem' },
      { source = 'git_status' },
    }
  }
})

keymap('n', '<space>f', ':Neotree toggle<CR>', { silent = true })
