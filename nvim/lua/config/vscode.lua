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
map("n", "]b", function() vscode.action("workbench.action.quickOpenNavigateNextInEditorPicker") end, { desc = "Switch to next tab", silent = true })
map("n", "[b", function() vscode.action("workbench.action.quickOpenNavigatePreviousInEditorPicker") end, { desc = "Switch to previous tab", silent = true })
map("n", "<leader>d", "<Cmd>q", { desc = "Close file", silent = true })

-- Quickfix navigation
map("n", "]q", function() vscode.action("editor.action.marker.next") end, { desc = "Move to next quickfix list entry", silent = true })
map("n", "[q", function() vscode.action("editor.action.marker.prev") end, { desc = "Move to previous quickfix list entry", silent = true })
map("n", "<leader>q", function() vscode.action("workbench.actions.view.problems") end, { desc = "Toggle the quickfix list window", silent = true })

-- Compiling
map("n", "<leader>bb", function() vscode.action("workbench.action.tasks.build") end, { desc = "Run build task", silent = true })

-- Searching
map("n", "<leader>ff", function() vscode.action("workbench.action.quickOpen") end, { desc = "Find files", silent = true })
map("n", "<leader>fg", function() vscode.action("workbench.action.findInFiles") end, { desc = "Grep for text", silent = true })
map("v", "<leader>fg",
  function()
    vscode.action("workbench.action.findInFiles", {
      args = {
        query = getVisualSelection(),
      }
    })
  end,
  { desc = "Grep for text", silent = true }
)

map("n", "<leader>fr", function() vscode.action("editor.action.goToReferences") end, { desc = "Find LSP references", silent = true })
map("n", "<leader>fs", function() vscode.action("workbench.action.showAllSymbols") end, { desc = "Find LSP workspace symbols", silent = true })

-- Git
map("n", "<leader>gd", function() vscode.action("gitlens.openFileHistory") end, { desc = "Git open file history", silent = true })
map("n", "<leader>gb", function() vscode.action("git.checkout") end, { desc = "Git checkout branch/tag", silent = true })
map("n", "<leader>gg", function() vscode.action("workbench.view.scm") end, { desc = "Open Git status", silent = true })

-- LSP
map("n", "gd", function() vscode.action("editor.action.revealDefinition") end, { desc = "Go to definition", silent = true})
map("n", "gD", function() vscode.action("editor.action.revealDeclaration") end, { desc = "Go to declaration", silent = true})
map("n", "gi", function() vscode.action("editor.action.goToImplementation") end, { desc = "Go to implementation", silent = true})
map("n", "go", function() vscode.action("editor.action.goToTypeDefinition") end, { desc = "Go to type definition", silent = true})
map("n", "<C-k>", function() vscode.action("editor.action.peekDefinition") end, { desc = "Display signature help", silent = true})
map("n", "crn", function() vscode.action("editor.action.rename") end, { desc = "Rename symbol", silent = true })
map("n", "ga", function() vscode.action("editor.action.quickFix") end, { desc = "Select code action", silent = true})
map("n", "]d", function() vscode.action("editor.action.marker.nextInFiles") end, { desc = "Go to next LSP diagnostic", silent = true })
map("n", "[d", function() vscode.action("editor.action.marker.prevInFiles") end, { desc = "Go to previous LSP diagnostic", silent = true })

-- Terminal
map("n", "<space>ot", function() vscode.action("workbench.action.terminal.toggleTerminal") end, { desc = "Open terminal", silent = true })
