return {
  'akinsho/toggleterm.nvim',
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.5
      end
    end,

    shade_terminals = false,
    open_mapping = [[<F1>]],
    direction = "vertical"
  },

  config = function(_, opts)
    require('toggleterm').setup(opts)
    local keymaps = require('general.keymaps')

    keymaps.add({
      mode = 'n',
      keys = '<C-\\>',
      action = ':ToggleTerm<CR>',
      desc = 'Open terminal',
    })

    keymaps.add({
      mode = 'i',
      keys = '<C-\\>',
      action = '<Esc>:ToggleTerm<CR>',
      desc = 'Open terminal',
    })
  end,
}
