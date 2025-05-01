local map = vim.keymap.set

-- Bind <C-c> to escape
map({ "i", "o", "v" }, "<C-c>", "<Esc>", { desc = "Escape to normal mode", silent = true })
map("s", "<C-c>", "<Esc>", { desc = "Escape to normal mode", silent = true })

-- Copy text to the system clipboard instead of to the neovim clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard", silent = true })

-- Buffer handling
map("n", "]b", ":bn<CR>", { desc = "Switch to next buffer", silent = true })
map("n", "[b", ":bp<CR>", { desc = "Switch to previous buffer", silent = true })
map("n", "<leader>d", ":bp|bd #<CR>", { desc = "Delete buffer", silent = true })
map("n", "<leader>D", ":bp|bd! #<CR>", { desc = "Force delete buffer", silent = true })
map("n", "<space>,", ":buffers<CR>", { desc = "List buffers", silent = true })

-- Repeated text shifting in visual mode
map("v", "<", "<gv", { desc = "Shift text left", silent = true })
map("v", ">", ">gv", { desc = "Shift text right", silent = true })

-- Quickfix list navigation
map("n", "]q", ":cnext<CR>", { desc = "Move to next quickfix list entry", silent = true })
map("n", "[q", ":cprev<CR>", { desc = "Move to previous quickfix list entry", silent = true })
map("n", "[Q", ":cfirst<CR>", { desc = "Move to first quickfix list entry", silent = true })
map("n", "]Q", ":clast<CR>", { desc = "Move to last quickfix list entry", silent = true })
map("n", "<leader>q", function()
	local qfwin = vim.fn.getqflist({ winid = 1 }).winid
	if qfwin > 0 then
		vim.api.nvim_win_close(qfwin, false)
	else
		vim.cmd("botright copen 15")
	end
end, { desc = "Toggle the quickfix list window", silent = true })

-- Location list navigations
map("n", "]w", ":lnext<CR>", { desc = "Move to next location list entry", silent = true })
map("n", "[w", ":lprev<CR>", { desc = "Move to previous location list entry", silent = true })
map("n", "[W", ":lfirst<CR>", { desc = "Move to first location list entry", silent = true })
map("n", "]W", ":llast<CR>", { desc = "Move to last location list entry", silent = true })
map("n", "<leader>w", function()
	local llwin = vim.fn.getloclist(1).winid
	if llwin > 0 then
		vim.api.nvim_win_close(llwin, false)
	else
		vim.cmd("botright lopen 15")
	end
end, { desc = "Toggle the location list window", silent = true })

-- Emacs readline command mode navigation
map("c", "<C-f>", function()
	if vim.fn.pumvisible() == 0 then
		return "<Right>"
	end
end, { desc = "Move forward one character", expr = true })

map("c", "<C-b>", function()
	if vim.fn.pumvisible() == 0 then
		return "<Left>"
	end
end, { desc = "Move backward one character", expr = true })

map("c", "<C-a>", function()
	if vim.fn.pumvisible() == 0 then
		return "<Home>"
	end
end, { desc = "Move to the beginning of the line", expr = true })

map("c", "<C-e>", function()
	if vim.fn.pumvisible() == 0 then
		return "<End>"
	end
end, { desc = "Move to the end of the line", expr = true })

map("c", "<esc>f", function()
	if vim.fn.pumvisible() == 0 then
		return "<S-Right>"
	end
end, { desc = "Move foward one word", expr = true })

map("c", "<esc>b", function()
	if vim.fn.pumvisible() == 0 then
		return "<S-Left>"
	end
end, { desc = "Move backward one word", expr = true })

map("c", "<C-d>", function()
	if vim.fn.pumvisible() == 0 then
		return "<Del>"
	end
end, { desc = "Delete the character after point", expr = true })

map("c", "<C-k>", function()
	local cursorpos = vim.fn.getcmdpos()
	local cmdlen = vim.fn.getcmdline():len()
	if cmdlen == cursorpos then
		return ""
	end

	return string.rep("<Del>", cmdlen - cursorpos + 1)
end, { desc = "Delete to the end of the line", expr = true })

vim.opt.cedit = ""

-- Emacs compile mode emulation using makeprg
local function compile_project()
	local makeprg = vim.o.makeprg
	if makeprg:find("%$%*") ~= nil then
		vim.fn.inputsave()

		vim.ui.input({
			prompt = string.format("Compile args (%s): ", makeprg),
		}, function(input)
			vim.fn.inputrestore()
			vim.cmd.redraw()

			if input == nil then
				return
			end

			if input ~= "" then
				vim.cmd.make({ args = { input }, bang = true })
			else
				vim.cmd.make({ bang = true })
			end
		end)
	else
		vim.cmd.make({ bang = true })
	end
end

map("n", "<leader>bb", function()
	vim.fn.inputsave()

	vim.ui.input({
		prompt = "Compile command: ",
		default = vim.o.makeprg,
		completion = "shellcmd",
	}, function(input)
		vim.fn.inputrestore()
		vim.cmd.redraw()

		if input == nil then
			return
		end

		vim.o.makeprg = input
		compile_project()
	end)
end, { desc = "Compile project", silent = true })

map("n", "<leader>bB", function()
	compile_project()
end, { desc = "Recompile project", silent = true })

-- Terminal keybinds
map("n", "<space>oT", "<Cmd>terminal<CR><Cmd>startinsert!<CR>", { desc = "Open terminal", silent = true })
map("t", "<C-g>", "<C-\\><C-N>", { desc = "Return to normal mode", silent = true })
map("t", "<C-w><C-w>", "<C-w>", { desc = "Delete previous word", silent = true })
map("t", "<C-w>h", "<Cmd>wincmd h<CR>", { desc = "Go to window left", silent = true })
map("t", "<C-w>j", "<Cmd>wincmd j<CR>", { desc = "Go to window below", silent = true })
map("t", "<C-w>k", "<Cmd>wincmd k<CR>", { desc = "Go to window above", silent = true })
map("t", "<C-w>l", "<Cmd>wincmd l<CR>", { desc = "Go to window right", silent = true })

-- Helper keybinds for executing commands and returning the output into a new buffer
map("n", "<leader>cc", function()
	vim.fn.inputsave()

	vim.ui.input({
		prompt = "Command: ",
		completion = "shellcmd",
	}, function(input)
		vim.fn.inputrestore()
		vim.cmd.redraw()

		if input == nil then
			return
		end

		vim.cmd("enew | 0r! " .. input)
	end)
end, { desc = "Run command and return the results in a new buffer", silent = true })

map("n", "<leader>cv", function()
	vim.fn.inputsave()

	vim.ui.input({
		prompt = "Command :",
		completion = "shellcmd",
	}, function(input)
		vim.fn.inputrestore()
		vim.cmd.redraw()

		if input == nil then
			return
		end

		vim.cmd("vert new | 0r! " .. input)
	end)
end, { desc = "Run command and return the results in a vertical split", silent = true })

map("n", "<leader>cs", function()
	vim.fn.inputsave()

	vim.ui.input({
		prompt = "Command :",
		completion = "shellcmd",
	}, function(input)
		vim.fn.inputrestore()
		vim.cmd.redraw()

		if input == nil then
			return
		end

		vim.cmd("new | 0r! " .. input)
	end)
end, { desc = "Run command and return the results in a horizontal split", silent = true })
