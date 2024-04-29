local M = {}

-- Function for generating a ctags file
local function ctags(command)
  -- Default list of ctags excludes
  local ctagsExcludes = {
    ".git",
    "target",
    "Cargo.lock",
    "go.mod",
    "go.sum"
  }

  -- Add global gitignore file to the excludes list
  local gitConfigFile = io.open(vim.env.HOME .. "/.gitconfig", "r")
  if gitConfigFile then
    local gitConfigContent = gitConfigFile:read "*a"
    gitConfigFile:close()

    local gitExcludesPath = string.match(gitConfigContent, "excludesFile = ([%w%p]+)")

    if gitExcludesPath then
      for line in io.lines(gitExcludesPath) do
        if not(string.find(line, "^%s*#")) then
          ctagsExcludes[#ctagsExcludes+1] = line
        end
      end
    end
  end

  -- Add local .gitignore files to the excludes list
  local gitIgnoreFile = io.open(".gitignore", "r")
  if gitIgnoreFile then
    gitIgnoreFile:close()

    for line in io.lines(".gitignore") do
      if not(string.find(line, "^%s*#")) then
        ctagsExcludes[#ctagsExcludes+1] = line
      end
    end
  end

  -- Add .ctagsignore files to the excludes list
  local ctagsIgnoreFile = io.open(".ctagsignore", "r")
  if ctagsIgnoreFile then
    ctagsIgnoreFile:close()

    for line in io.lines(".ctagsignore") do
      if not(string.find(line, "^%s*#")) then
        ctagsExcludes[#ctagsExcludes+1] = line
      end
    end
  end


  local ctagsExcludesArguments = ""
  for _, exclude in ipairs(ctagsExcludes) do
    ctagsExcludesArguments = ctagsExcludesArguments .. string.format('--exclude="%s" ', exclude)
  end

  local tagsUpdated = false
  local tagsFile = io.open("tags", "r")
  if tagsFile then
    tagsUpdated = true
    tagsFile:close()
  end

  local ctagsCommand = "ctags -R " .. ctagsExcludesArguments .. "." .. " 2>&1"
  local handle = io.popen(ctagsCommand)
  local output = handle:read("*a")
  local rc = handle:close()

  if rc == nil then
    print(output)
  elseif not tagsUpdated then
    print("Tags file generated")
  end

end

function M.setup()
  -- Create ctags command
  vim.api.nvim_create_user_command("Ctags", ctags, {
    nargs = '?',
    desc = "Run ctags"
  })
end

return M
