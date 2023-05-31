-- Helper function for mapping keys
function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Screen buffer navigation
--keymap('n', '<Leader>]', ':bn<CR>', { silent = true })
--keymap('n', '<Leader>[', ':bp<CR>', { silent = true })
--keymap('n', '<Leader>d', ':bd<CR>', { silent = true })

-- Multiple shifting using angle brackets
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Set undo to only undo lines in insert mode
keymap('i', '<C-U>', '<C-G>u<C-U>')

-- Pwn snippet
local pwnsnippet = vim.fn.stdpath('config') .. '/snippets/skeleton-pwn.py'
if vim.fn.filereadable(pwnsnippet) then
    keymap('n', ',e', ':-1read ' .. pwnsnippet .. '<CR>3j$i', { silent = true })
end

-- Use '\y' to copy text to the system clipboard
keymap('n', '<Leader>y', '"+y')
keymap('v', '<Leader>y', '"+y')

-- Terminal escape
keymap('t', '<Esc>', '<C-\\><C-n>')

-- Run ctags in the background using tgen if the tags file exists
if vim.fn.has('unix') == 1 then
    keymap('n', '<leader>c', ':!tgen<CR>', { silent = true })

    local function RunCtagsBack()
        if vim.fn.filereadable("tags") == 1 then
            vim.cmd(':execute \'silent !tgen\' | redraw!')
        end
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function() vim.schedule(RunCtagsBack) end,
    })
    --vim.cmd('autocmd BufWritePost * :call RunCtagsBack()')
end

-- Telescope keybinds
keymap('n', '<leader>t', ':Telescope tags<CR>', { silent = true })
keymap('n', '<leader>f', ':Telescope find_files<CR>', { silent = true })
keymap('n', '<leader>;', ':Telescope buffers<CR>', { silent = true })
keymap('n', '<leader>g', ':Telescope live_grep<CR>', { silent = true })
keymap('n', '<leader>s', ':Telescope grep_string<CR>', { silent = true })

-- Don't remove split if buffer is deleted
keymap('n', '<leader>d', ':bp|bd #<CR>', { silent = true})

-- Floating terminal keybinds
keymap('n', '<space>t', ':FloatermToggle<CR>', { silent = true })
keymap('n', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('i', '<F1>', '<Esc>:FloatermToggle<CR>', { silent = true })
keymap('v', '<F1>', ':FloatermToggle<CR>', { silent = true })
keymap('t', '<F1>', '<C-\\><C-n>:FloatermToggle<CR>', { silent = true })

-- Bind make to F2
keymap('n', '<F2>', ':make<CR>', { silent = true })

-- Right Click Context Menu (Copy-Cut-Paste) for gui
if vim.fn.exists('GuiLoaded') == 1 then
  keymap('n', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
  keymap('i', '<RightMouse>', '<Esc>:call GuiShowContextMenu()<CR>', { silent = true })
  keymap('v', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
end

-- Setup debugging
options = { silent = true }
keymap("n", "<F3>", ":lua require'dapui'.toggle()<CR>", options)
keymap("n", "<F4>", ":lua require'dap'.terminate()<CR>", options)
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", options)
keymap("n", "<F6>", ":lua require'dap'.step_over()<CR>", options)
keymap("n", "<F7>", ":lua require'dap'.step_into()<CR>", options)
keymap("n", "<F8>", ":lua require'dap'.step_out()<CR>", options)
keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", options)
keymap("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", options)
keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", options)
keymap("v", "<M-k>", ":lua require'dapui'.eval()<CR>", options)

-- Open nerdtree with keybind
keymap('n', '<space>f', ':NeoTreeFocusToggle<CR>', { silent = true })

-- Top status bar keybinds
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<leader>[', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>]', '<Cmd>BufferNext<CR>', opts)
-- Goto buffer in position...
map('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
-- Pin/unpin buffer
map('n', '<leader>0', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<leader>d', '<Cmd>BufferClose<CR>', opts)

-- Markdown preview
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
