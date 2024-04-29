local M = {}

-- Define the GUI font for the platform
M.guifont = 'Source Code Pro'

function M.setup()
  -- Add zshrc configuration to shell commands
  vim.opt.shellcmdflag = '-ic'
end

return M
