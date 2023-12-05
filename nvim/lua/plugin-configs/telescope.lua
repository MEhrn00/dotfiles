local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<c-u>"] = false,
        ["<c-e>"] = actions.preview_scrolling_down,
        ["<C-y>"] = actions.preview_scrolling_up,
      },
    },
  },

  pickers = {
    buffers = {
      theme = "ivy",
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
        },
      }
    },

    find_files = {
      theme = "ivy"
    },

    grep_string = {
      theme = "ivy",
    },

    live_grep = {
      theme = "ivy",
    },

    lsp_definitions = {
      theme = "ivy",
    },

    lsp_diagnostics = {
      theme = "ivy",
    },

    lsp_implementations = {
      theme = "ivy",
    },

    lsp_references = {
      theme = "ivy",
    },

    lsp_type_definitions = {
      theme = "ivy",
    },

    tags = {
      theme = "ivy",
    },

  },
}

function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

-- Telescope keybinds
local opts = { silent = true }
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>t', builtin.tags, opts)
vim.keymap.set('n', '<leader>f', builtin.find_files, opts)
vim.keymap.set('n', '<leader>;', builtin.buffers, opts)
vim.keymap.set('n', '<leader>g', builtin.live_grep, opts)
vim.keymap.set('v', '<leader>g', function()
  local selectionText = vim.getVisualSelection()
  builtin.live_grep({ default_text = selectionText })
end, opts)
