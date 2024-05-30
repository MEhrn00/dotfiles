local M = {}

function M.setup()
	-- Turn on line numbers
	vim.opt.number = true

	-- Enable syntax highlighting
	--vim.cmd.syntax('on')

	-- Enable filetype plugin loading
	vim.cmd.filetype({
		"indent",
		"plugin",
		"on",
	})

	-- Set the scrolloff to 5 lines
	vim.opt.scrolloff = 5

	-- Show trailing whitespaces as '-' and tab characters a '>'
	vim.opt.list = true
	vim.opt.listchars = { trail = "-", tab = "> " }

	-- Turn on the mouse
	vim.opt.mouse = "a"

	-- Set the buffer title to display the file name
	vim.opt.title = true

	-- Disable netrw history
	vim.g.netrw_dirhistmax = 0

	-- Set tabs equal to 4 spaces by default
	vim.opt.expandtab = true
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4

	-- Enable auto indenting
	vim.opt.smartindent = true
	vim.opt.autoindent = true

	-- Don't show the vim mode and command keys in the status
	vim.opt.showmode = false
	vim.opt.showcmd = false

	-- Show a column line at 90 characters by default
	vim.opt.colorcolumn = "90"

	-- Set the text width to 90 characters by default
	vim.opt.textwidth = 90

	-- Turn off search highlighting and turn incremental search on
	vim.opt.hlsearch = false
	vim.opt.incsearch = true

	-- Set the default 'gf' search path to the current directory
	vim.opt.path = { ".", "**" }

	-- Configure wildmenu
	vim.opt.wildmenu = true

	-- More natural splits
	vim.opt.splitbelow = true
	vim.opt.splitright = true

	-- Basic general completion settings
	vim.opt.omnifunc = "syntaxcomplete#Complete"
	vim.opt.completeopt = "menuone,longest,noselect,noinsert"
	vim.opt.shortmess = "filnxtToOFc"

	-- Live search and replace
	vim.opt.icm = "nosplit"

	-- Enable termdebug
	vim.cmd([[packadd termdebug]])
	vim.g.termdebug_wide = 1

	-- Allow symbols in the number column
	-- vim.opt.signcolumn = 'yes'
end

return M
