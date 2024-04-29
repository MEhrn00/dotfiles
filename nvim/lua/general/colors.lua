local M = {}

function M.setup(scheme)
  -- Set the background to dark and allow gui colors in the terminal
  vim.opt.bg = 'dark'
  vim.opt.termguicolors = true
end

return M
