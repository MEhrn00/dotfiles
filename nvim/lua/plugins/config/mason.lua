return {
  "williamboman/mason.nvim",
  dependencies = {
    { 'williamboman/mason-lspconfig', config = false },
  },
  lazy = false,
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup()
  end,
}
