local vscode = require("vscode")
local map = vim.keymap.set

local function getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- Buffer handling
map("n", "<leader>]", function() vscode.action("workbench.action.quickOpenNavigateNextInEditorPicker") end, { desc = "Switch to next tab", silent = true })
map("n", "<leader>[", function() vscode.action("workbench.action.quickOpenNavigatePreviousInEditorPicker") end, { desc = "Switch to previous tab", silent = true })
map("n", "<leader>d", "<Cmd>q", { desc = "Close file", silent = true })

-- Quickfix navigation
map("n", "]q", function() vscode.action("editor.action.marker.next") end, { desc = "Move to next quickfix list entry", silent = true })
map("n", "[q", function() vscode.action("editor.action.marker.prev") end, { desc = "Move to previous quickfix list entry", silent = true })

-- Compiling
map("n", "<leader>b", function() vscode.action("workbench.action.tasks.build") end, { desc = "Run build task", silent = true })

-- Searching
map("n", "<leader>s", function() vscode.action("workbench.action.findInFiles") end, { desc = "Search for text", silent = true })
map("v", "<leader>s",
  function()
    vscode.action("workbench.action.findInFiles", {
      args = {
        query = getVisualSelection(),
      }
    })
  end,
  { desc = "Search for text", silent = true }
)

map({"n", "v"}, "<leader>r", function() vscode.action("references-view.findReferences") end, { desc = "LSP references", silent = true })
map("n", "<leader>S", function() vscode.action("workbench.action.showAllSymbols") end, { desc = "Search LSP workspace symbols", silent = true })

-- Git
map("n", "<leader>gc", function() vscode.action("git.checkout") end, { desc = "Git checkout branch/tag", silent = true })
map("n", "<leader>gd", function() vscode.action("gitlens.openFileHistory") end, { desc = "Git open file history", silent = true })

-- LSP
map("n", "ga", function() vscode.action("editor.action.quickFix") end, { desc = "Select code action", silent = true})
