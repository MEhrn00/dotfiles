require('neogit').setup{
  kind = "auto",
  graph_style = "unicode",
  integrations = {
    telescope = true,
    diffview = true
  }
}

-- Open Neogit
keymap('n', '<space>g', ':Neogit<CR>', { silent = true })
