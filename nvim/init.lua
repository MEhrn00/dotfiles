-- Turn on line numbers
vim.opt.number = true

-- Enable filetype plugin
vim.cmd("filetype plugin on")

-- Set the scrolloff
vim.opt.scrolloff = 5

-- Save cursor position in file
vim.cmd [[
augroup vimStartup
    au!
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
]]

-- Show trailing whitespace as '-' and hard tabs as '>'
vim.opt.list = true
vim.opt.listchars = 'tab:> ,trail:-'

-- Turn on the mouse
vim.opt.mouse = 'a'

-- Set the buffer title to display the file name
vim.opt.title = true

-- Disable netrw history
vim.g.netrw_dirhistmax = 0

-- Set tabs equal to 4 spaces by default
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Don't show the vim mode
vim.opt.showmode = false
vim.opt.showcmd = false

-- Set color options
vim.opt.bg = 'dark'
vim.opt.termguicolors = true

-- Show a visible column line at 90 characters
vim.opt.colorcolumn = '90'
vim.opt.textwidth = 90

-- Turn off search highlighting but turn incremental search on
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Disable neovim status line
vim.opt.laststatus = 1

-- Set the 'gf' search paths
vim.opt.path = {
    '.',
    '/usr/include',
    '**',
}

-- Turn on the wildmenu
vim.opt.wildmenu = true

-- More natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Basic general completion settings
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.completeopt = 'menuone,longest'
vim.opt.shortmess = 'filnxtToOFc'

-- Live substitute
vim.opt.icm = 'nosplit'

-- Enable termdebug
vim.cmd [[packadd termdebug]]
vim.g.termdebug_wide = 1

-- Include .zshrc when issuing shell commands
vim.opt.shellcmdflag = '-ic'

-- Neovide settings
if vim.fn.has('win32') == 1 then
    vim.opt.guifont = 'Consolas:h9'
else
  if vim.g.neovide then
    vim.opt.guifont = 'Source Code Pro:h5'
  else
    vim.opt.guifont = 'Source Code Pro:h9'
  end
end
vim.g.neovide_fullscreen = 'v:false'
vim.g.neovide_remember_window_size = 'v:true'
vim.g.neovide_cursor_vfx_mode = 'sonicboom'

-- Make completions work better with nvim lsp
vim.opt.completeopt = 'menuone,longest,noselect,noinsert'

-- Disable netrw and use Neotree instead
vim.g.loaded_netrwPlugin = 1

-- Allow symbols in the column
vim.opt.signcolumn = 'yes'

-- Function for generating a ctags file
function ctags(command)
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

-- Add more specific filetype detections
local function yaml_ftdetect(path, bufnr)
  if vim.fn.glob(vim.fn.getcwd() .. "/**/ansible.cfg") ~= "" then
    return "yaml.ansible"
  end
  return "yaml"
end

vim.filetype.add({
  extension = {
    yaml = yaml_ftdetect,
    yml = yaml_ftdetect,
  }
})

vim.api.nvim_create_user_command("Ctags", ctags, {
  nargs = '?',
  desc = "Run ctags"
})

-- Load general keymaps and the keymap function
require('keymaps')

-- Load plugins
require('plugins')
