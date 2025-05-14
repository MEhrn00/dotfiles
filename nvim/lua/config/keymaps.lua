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

-- Emacs compile mode emulation
local function do_compile_project(command)
	local efm = vim.bo.efm
	if efm == nil or efm == "" then
		efm = vim.o.efm
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	local winid = vim.api.nvim_open_win(bufnr, true, {
		split = "below",
		height = 20,
		win = -1,
	})

	vim.keymap.set("n", "q", "<Cmd>close<CR>", {
		buffer = bufnr,
		silent = true,
		desc = "Close buffer",
	})

	vim.keymap.set("n", "<CR>", function()
		local qfwin = vim.fn.getqflist({ winid = 1 }).winid
		if qfwin == 0 then
			vim.api.nvim_win_hide(winid)
			vim.cmd("botright copen 20")
		end
	end, { buffer = bufnr, silent = true, desc = "Open quickfix list" })

	vim.api.nvim_set_current_buf(bufnr)

	local jid = vim.fn.jobstart(command, {
		term = true,
		on_exit = function(_)
			vim.fn.setqflist({}, "r", {
				title = command,
				lines = vim.api.nvim_buf_get_lines(bufnr, 0, -2, false),
				efm = efm,
			})
		end,
	})

	vim.api.nvim_buf_set_name(bufnr, string.format("(%d) %s", jid, command))
end

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
				makeprg = makeprg:gsub("%$%*", input)
			end

			do_compile_project(makeprg)
		end)
	else
		do_compile_project(makeprg)
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

--- LSP keybinds
map("n", "<leader>Q", function()
	local qfwin = vim.fn.getqflist({ winid = 1 }).winid
	if qfwin > 0 then
		vim.api.nvim_win_close(qfwin, false)
	end

	vim.diagnostic.setqflist({
		title = "Project LSP Diagnostics",
		open = false,
	})

	vim.cmd("botright copen 15")
end, { desc = "Send project LSP diagnostics to quickfix list", silent = true })

map("n", "<leader>E", function()
	local qfwin = vim.fn.getqflist({ winid = 1 }).winid
	if qfwin > 0 then
		vim.api.nvim_win_close(qfwin, false)
	end

	vim.fn.setqflist({}, "r", {
		title = "Buffer LSP Diagnostics",
		items = vim.diagnostic.toqflist(vim.diagnostic.get(0)),
	})

	vim.cmd("botright copen 15")
end, { desc = "Send buffer LSP diagnostics to quickfix list", silent = true })

map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Display signature help", silent = true })
map("n", "ga", vim.lsp.buf.code_action, { desc = "Code action", silent = true })
