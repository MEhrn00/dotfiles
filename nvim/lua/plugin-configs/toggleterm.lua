require("toggleterm").setup{
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
}

keymap('n', '<C-\\>', ':ToggleTerm<CR>')
keymap('i', '<C-\\>', '<Esc>:ToggleTerm<CR>')
