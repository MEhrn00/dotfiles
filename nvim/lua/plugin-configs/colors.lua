vim.cmd.colorscheme "codedark"

local colorMaps = {
  Normal = {
    bg = "NONE"
  },

  EndOfBuffer = {
    bg = "NONE"
  },

  ColorColumn = {
    bg = "gray"
  },

  SignColumn = {
    bg = "NONE"
  },

  LineNr = {
    fg = "gray",
    bg = "NONE"
  },

  NormalFloat = {
    link = "Pmenu"
  },

  ErrorMsg = {
    fg = "LightRed",
    bg = "NONE"
  },

  WarningMsg = {
    link = "ErrorMsg"
  },

  DiagnosticFloatingError = {
    link = "DiagnosticVirtualTextError"
  },

  DiagnosticFloatingWarning = {
    link = "DiagnosticVirtualTextWarn"
  },
}

for group, opt in pairs(colorMaps) do
  --vim.api.nvim_set_hl(0, group, opt)
end
