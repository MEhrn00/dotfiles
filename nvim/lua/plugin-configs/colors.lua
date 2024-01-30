vim.cmd.colorscheme "codedark"

local colorMaps = {
  ColorColumn = {
    bg = "gray"
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


if not vim.g.neovide then
  local tuiColors = {
    Normal = {
      bg = "NONE"
    },

    EndOfBuffer = {
      bg = "NONE"
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
  }

  for group, colors in pairs(tuiColors) do
    colorMaps[group] = colors
  end
end

for group, color in pairs(colorMaps) do
  vim.api.nvim_set_hl(0, group, color)
end
