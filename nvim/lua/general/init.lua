local M = {}

function M.setup()
  require('general.options').setup()
  require('general.keymaps').setup()

  -- require('general.colors').setup()
  -- require('general.statusline').setup()

  if vim.fn.has('win32') == 1 then
    require('general.windows').setup()
  elseif vim.fn.has('unix') == 1 then
    require('general.linux').setup()
  end

  if vim.g.neovide then
    require('general.neovide').setup()
  end

  if vim.g.neovide or vim.fn.has('gui') then
    require('general.gui').setup()
  end

  require('general.ctags').setup()
  require('general.commenttoggle').setup()
end

return M
