-- Turn on line numbers
vim.opt.number = true

-- Enable filetype plugins
vim.cmd.filetype({
	"indent",
	"plugin",
	"on",
})

-- Colors
vim.opt.bg = "dark"
vim.opt.termguicolors = true

-- Set the scrolloff to 5 lines
vim.opt.scrolloff = 5

-- Make trailing whitespace and hard tabs visible
vim.opt.list = true
vim.opt.listchars = { trail = "-", tab = "│ " }

-- Cursor column
vim.opt.colorcolumn = "90"

-- Enable the mouse
vim.opt.mouse = "a"

-- Set the buffer title to display the file name
vim.opt.title = true

-- Netrw settings
vim.g.netrw_dirhistmax = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.api.nvim_set_hl(0, "netrwMarkFile", {
	italic = true,
	undercurl = true,
	bg = 2895411, -- NvimDarkGrey3
})

-- Set tabs equal to 4 spaces
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Indentation
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Disable mode status and command keys
vim.opt.showmode = false
vim.opt.showcmd = false

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- gf search paths
vim.opt.path = { ".", "**" }

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = {
	"fuzzy",
	"pum",
}
vim.opt.pumheight = 20

-- Natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Completion settings
vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.opt.completeopt = {
	"menu",
	"fuzzy",
	"noselect",
	"popup",
}

vim.opt.shortmess = "filnxtToOFc"

-- Live search and replace
vim.opt.icm = "split"

-- Termdebug
vim.g.termdebug_wide = 1

-- Quickfix filter
vim.cmd.packadd("cfilter")

-- Set NVIM_REMOTE_SOCKET
vim.fn.setenv("NVIM_REMOTE_SOCKET", vim.v.servername)
