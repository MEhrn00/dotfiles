return {
  'nvim-treesitter/nvim-treesitter-context',
  lazy = false,
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      import = 'plugins.config.treesitter',
    },
  },
  main = 'treesitter-context',
  config = true,
}
