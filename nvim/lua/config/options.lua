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
	bg = "NvimDarkGrey3",
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

-- Natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Completion settings
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.completeopt = "menuone,longest,noselect,noinsert"
vim.opt.shortmess = "filnxtToOFc"

-- Live search and replace
vim.opt.icm = "nosplit"

-- Termdebug
vim.cmd.packadd("termdebug")
vim.g.termdebug_wide = 1

-- Quickfix filter
vim.cmd.packadd("cfilter")

-- Cursor
vim.opt.guicursor = {
	"n-v-c-ci-sm:block",
	"i-ve:ver25",
	"r-cr-o:hor20",
}

-- Set NVIM_REMOTE_SOCKET
vim.fn.setenv("NVIM_REMOTE_SOCKET", vim.v.servername)

-- Open the quick/location lists in a full window
vim.api.nvim_create_user_command("Copew", function(opts)
	if opts.args ~= nil and opts.args:len() > 0 then
		vim.cmd("botright copen " .. opts.args)
	else
		vim.cmd("botright copen 15")
	end
end, { nargs = "*" })

vim.api.nvim_create_user_command("Lopew", function(opts)
	if opts.args ~= nil and opts.args:len() > 0 then
		vim.cmd("botright lopen " .. opts.args)
	else
		vim.cmd("botright lopen 15")
	end
end, { nargs = "*" })
