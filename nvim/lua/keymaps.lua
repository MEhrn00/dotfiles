-- Helper function for mapping keys
function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Default screen buffer navigation (this gets overridden by Barbar when it is loaded)
keymap('n', '<Leader>]', ':bn<CR>', { silent = true })
keymap('n', '<Leader>[', ':bp<CR>', { silent = true })
keymap('n', '<Leader>d', ':bd<CR>', { silent = true })

-- Multiple tab shifting using angle brackets
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Set undo to only undo lines in insert mode
keymap('i', '<C-U>', '<C-G>u<C-U>')

-- Bind C-c to escape when not in normal mode
keymap('i', '<C-c>', '<Esc>')
keymap('v', '<C-c>', '<Esc>')
keymap('o', '<C-c>', '<Esc>')

-- Command entry emacs keybinds
keymap('c', '<C-a>', '<Home>')
keymap('c', '<C-f>', '<Right>')
keymap('c', '<M-f>', '<S-Right>')
keymap('c', '<C-b>', '<Left>')
keymap('c', '<M-b>', '<S-Left>')

-- Load pwn snippet
local pwnsnippet = vim.fn.stdpath('config') .. '/snippets/skeleton-pwn.py'
if vim.fn.filereadable(pwnsnippet) then
    keymap('n', ',e', ':-1read ' .. pwnsnippet .. '<CR>3j$i', { silent = true })
end

-- Use '\y' to copy text to the system clipboard
keymap('n', '<Leader>y', '"+y')
keymap('v', '<Leader>y', '"+y')

-- Set escape to be the terminal escape character
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Don't remove split if buffer is deleted
keymap('n', '<leader>d', ':bp|bd #<CR>', { silent = true})

-- Right Click Context Menu (Copy-Cut-Paste) for gui
if vim.fn.exists('GuiLoaded') == 1 then
  keymap('n', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
  keymap('i', '<RightMouse>', '<Esc>:call GuiShowContextMenu()<CR>', { silent = true })
  keymap('v', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
end

-- Toggle line comments on visual mode selection
local function toggleCommentBlock()
  local cms = vim.bo.cms
  if cms == nil or cms == '' then
    print("Comment string is empty for filetype: " .. vim.bo.filetype)
    return
  end

  local cursorPos = vim.api.nvim_win_get_cursor(0)

  local commentString = string.gsub(cms, "%%s", "")
  local tabchar = vim.bo.expandtab and ' ' or '\t'

  vim.cmd('noau normal! "vy"')
  local lineStartNumber = vim.api.nvim_buf_get_mark(0, "<")[1]
  local lineEndNumber = vim.api.nvim_buf_get_mark(0, ">")[1]

  -- Check the start of the visual block to see if the block needs to be commented or not.
  -- Normally, people will have different keybinds for inserting and removing line
  -- comments. This will instead check if the block needs to be commented based on whether
  -- or not the first line selected is commented.
  local line = vim.fn.getline(lineStartNumber)
  local lineTrimmed = string.gsub(line, "^%s+", "")

  if string.match(lineTrimmed, "^" .. commentString) ~= nil then -- Text already has a comment
    local replaceString = string.format("'<,'>s!^\\(%s*\\)%s!\\1!", tabchar, commentString)
    vim.cmd(replaceString)
    cursorPos[2] = cursorPos[2] - commentString:len()
  else -- Text needs to be commented
    local prefixCount = 999

    for i = lineStartNumber, lineEndNumber do
      line = vim.fn.getline(i)
      if string.match(line, "%g") then
        local index = string.find(line, "%g")

        local indexNumber = tonumber(index)
        if indexNumber ~= nil and indexNumber < prefixCount then
          prefixCount = indexNumber
        end -- if indexNumber ~= nil ...
      end -- if string.match(line, ...
    end -- for i = lineStartNumber, lineEndNumber

    prefixCount = prefixCount - 1

    for i = lineStartNumber, lineEndNumber do
      line = vim.fn.getline(i)
      local subFormat = string.format("^%s", string.rep(tabchar, prefixCount))
      line = string.gsub(line, subFormat, "")

      if line ~= '' and not string.match(line, "^" .. commentString) then
        local replaceString = string.format("%s%s%s", string.rep(tabchar, prefixCount), commentString, line)
        vim.fn.setline(i, replaceString)
      end

    end -- for i = lineStartNumber, lineEndNumber

    cursorPos[2] = cursorPos[2] + commentString:len()
  end -- if string.match(start_line_trimmed, "^" .. commentString) ~= nil

  vim.api.nvim_win_set_cursor(0, cursorPos)
end

local function toggleComment()
  local cms = vim.bo.cms
  if cms == nil or cms == '' then
    print("Comment string is empty for filetype: " .. vim.bo.filetype)
    return
  end

  local cursorPos = vim.api.nvim_win_get_cursor(0)

  local commentString = string.gsub(cms, "%%s", "")
  local tabchar = vim.bo.expandtab and ' ' or '\t'

  local lineNumber = cursorPos[1]
  local line = vim.fn.getline(lineNumber)
  local lineTrimmed = string.gsub(line, "^%s+", "")

  if string.match(lineTrimmed, "^" .. commentString) ~= nil then -- Text already has a comment
    --local replaceString = string.format("s!^\\(%s*\\)%s!\\1!", tabchar, commentString)
    local replaceString = string.format("s!%s!!", commentString)
    vim.cmd(replaceString)
    cursorPos[2] = cursorPos[2] - commentString:len()
  else -- Text needs to be commented
    local replaceString = string.format("s!^\\(%s*\\)!\\1%s!", tabchar, commentString)
    vim.cmd(replaceString)
    cursorPos[2] = cursorPos[2] + commentString:len()
  end

  vim.api.nvim_win_set_cursor(0, cursorPos)
end

vim.keymap.set('v', "<C-_>", toggleCommentBlock)
vim.keymap.set('n', "<C-_>", toggleComment)
