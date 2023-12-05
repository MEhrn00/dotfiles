-- Dev icons
require('nvim-web-devicons').setup()

-- Setup status line
require('lualine').setup{
  options = {
    theme = 'nord'
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },

  tabline = {}
}
