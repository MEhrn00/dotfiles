return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  opts = {
    ensure_installed = { 'c', 'rust', 'go', 'lua' },
    auto_install = true,
  },

  main = 'nvim-treesitter.configs',
  config = true,
}
