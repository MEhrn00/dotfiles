local map = vim.keymap.set

-- System clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard", silent = true })

-- Bind <C-c> to escape
map({ "i", "o", "v" }, "<C-c>", "<Esc>", { desc = "Escape to normal mode", silent = true })
map("s", "<C-c>", "<Esc>", { desc = "Escape to normal mode", silent = true })

-- Buffer handling
map("n", "<leader>]", ":bn<CR>", { desc = "Switch to next buffer", silent = true })
map("n", "<leader>[", ":bp<CR>", { desc = "Switch to previous buffer", silent = true })
map("n", "<leader>d", ":bp|bd #<CR>", { desc = "Delete buffer", silent = true })
map("n", "<leader>D", ":bp|bd! #<CR>", { desc = "Force delete buffer", silent = true })
map("n", "<leader>;", ":buffers<CR>", { desc = "List buffers", silent = true })

-- Repeated text shift in visual mode
map("v", "<", "<gv", { desc = "Shift text left", silent = true })
map("v", ">", ">gv", { desc = "Shift text right", silent = true })

-- Quickfix navigation
map("n", "]q", ":cnext<CR>", { desc = "Move to next quickfix list entry", silent = true })
map("n", "[q", ":cprev<CR>", { desc = "Move to previous quickfix list entry", silent = true })
map("n", "[Q", ":cfirst<CR>", { desc = "Move to first quickfix list entry", silent = true })
map("n", "]Q", ":clast<CR>", { desc = "Move to last quickfix list entry", silent = true })

-- Location list navigation
map("n", "]w", ":lnext<CR>", { desc = "Move to next location list entry", silent = true })
map("n", "[w", ":lprev<CR>", { desc = "Move to previous location list entry", silent = true })
map("n", "[W", ":lfirst<CR>", { desc = "Move to first location list entry", silent = true })
map("n", "]W", ":llast<CR>", { desc = "Move to last location list entry", silent = true })

-- Emacs commandline navigation
map("c", "<C-f>", 'wildmenumode() ? "<lt>Down>" : "<lt>Right>"', { desc = "Move forward one character", expr = true })
map("c", "<C-b>", 'wildmenumode() ? "<lt>Up>" : "<lt>Left>"', { desc = "Move backward one character", expr = true })
map(
	"c",
	"<C-n>",
	'wildmenumode() ? "<lt>Right>" : "<lt>Down>"',
	{ desc = "Move down to next wildmenu entry", expr = true }
)
map(
	"c",
	"<C-p>",
	'wildmenumode() ? "<lt>Left>" : "<lt>Up>"',
	{ desc = "Move up to previous wildmenu entry", expr = true }
)
map(
	"c",
	"<C-a>",
	'wildmenumode() ? "<lt>C-a>" : "<lt>Home>"',
	{ desc = "Move to the beginning of the line", expr = true }
)
map("c", "<C-e>", 'wildmenumode() ? "<lt>C-e>" : "<lt>End>"', { desc = "Move to the end of the line", expr = true })
map("c", "<esc>f", 'wildmenumode() ? "" : "<lt>S-Right>"', { desc = "Move foward one word", expr = true })
map("c", "<esc>b", 'wildmenumode() ? "" : "<lt>S-Left>"', { desc = "Move backward one word", expr = true })
map(
	"c",
	"<C-d>",
	'wildmenumode() ? "<lt>C-d>" : "<lt>Del>"',
	{ desc = "Delete the character after point", expr = true }
)
map("c", "<C-k>", function()
	local idx = vim.fn.getcmdpos()
	local cmdlen = vim.fn.getcmdline():len()
	if cmdlen == idx then
		return ""
	end

	return string.rep("<Del>", cmdlen - idx + 1)
end, { desc = "Delete to the end of the line", expr = true })

-- Set commandline cedit keybind to <C-y>
vim.opt.cedit = ""

-- Compiling
local compilemode = require("custom-plugins.compilemode")
compilemode.setup()
map("n", "<leader>bB", compilemode.recompile, { desc = "Recompile project", silent = true })
map("n", "<leader>bb", compilemode.compile, { desc = "Compile project", silent = true })

-- Terminal
map("n", "<space>oT", "<Cmd>terminal<CR><Cmd>startinsert!<CR>", { desc = "Open terminal", silent = true })
map("t", "<C-g>", "<C-\\><C-N>", { desc = "Return to normal mode", silent = true })
map("t", "<C-w><C-w>", "<C-w>", { desc = "Delete previous word", silent = true })
map("t", "<C-w>h", "<Cmd>wincmd h<CR>", { desc = "Go to window left", silent = true })
map("t", "<C-w>j", "<Cmd>wincmd j<CR>", { desc = "Go to window below", silent = true })
map("t", "<C-w>k", "<Cmd>wincmd k<CR>", { desc = "Go to window above", silent = true })
map("t", "<C-w>l", "<Cmd>wincmd l<CR>", { desc = "Go to window right", silent = true })
