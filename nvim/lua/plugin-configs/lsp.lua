local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  local telescope = require('telescope.builtin')

  -- Command keybinds for nvim lsp such as documentation and goto implementation
  vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
  vim.keymap.set('n', 'gD', telescope.lsp_type_definitions, opts)
  vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
  vim.keymap.set('n', '<leader>e', telescope.diagnostics, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)

  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.format_on_save({
  format_opts = {
    async = true,
    timeout_ms = 10000,
  },

  servers = {
    ['rust_analyzer'] = {'rust'},
    ['gopls'] = {'go'},
    ['clangd'] = {'c', 'cpp'},
    ['terraformls'] = {'terraform'},
  }
})

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})


require('mason').setup({}) -- Mason for handling language servers
local inlayHints = require("lsp-inlayhints")
inlayHints.setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer',
    'gopls',
    'clangd',
    'lua_ls'
  },

  handlers = {
    lsp_zero.default_setup,

    rust_analyzer = function()
      require('lspconfig').rust_analyzer.setup({
        on_attach = function(client, bufnr)
          inlayHints.on_attach(client, bufnr)
        end,

        settings = {
          checkOnSave = {
            command = "clippy"
          },

          cargo = {
            features = "all"
          },

          hint = {
            enable = true,
          }
        }
      })
    end,

    clangd = function ()
      require('lspconfig').clangd.setup({
        on_attach = function(client, bufnr)
          inlayHints.on_attach(client, bufnr)
        end,

        settings = {
          hint = {
            enable = true,
          }
        }
      })
    end,
  },
})


local cmp = require('cmp') -- Completion behavior
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local lspkind = require("lspkind")

-- Snippets load
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = nil,
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),

  experimental = {
    ghost_text = true
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
    })
  }
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

