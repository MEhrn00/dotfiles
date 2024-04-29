local M = {}

local function toggleBlockComment()
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

local function toggleLineComment()
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

function M.setup()
  local keymaps = require('general.keymaps')

  keymaps.add({
    mode = 'v',
    keys = '<C-_>',
    action = toggleBlockComment,
    desc = 'Toggle comment block',
  })

  keymaps.add({
    mode = 'n',
    keys = '<C-_>',
    action = toggleLineComment,
    desc = 'Toggle line comment',
  })

end

return M
