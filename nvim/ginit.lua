-- Set the font size
vim.s.fontsize = 9

local function AdjustFontSize(amt)
    vim.s.fontsize = vim.s.fontsize + vim.a.amt
    if vim.fn.has('win32') then
        vim.opt.guifont = "Consolas:h" . vim.s.fontsize
    else
        vim.opt.guifont = "Source Code Pro:h" . vim.s.fontsize
    end
end

function keymap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Font resize
keymap('n', '<C-ScrollWheelUp>', ':call AdjustFonstSize(1)<CR>', { silent = true })
keymap('n', '<C-ScrollWheelDown>', ':call AdjustFonstSize(-1)<CR>', { silent = true })
keymap('i', '<C-ScrollWheelUp>', '<Esc>:call AdjustFonstSize(1)<CR>a', { silent = true })
keymap('i', '<C-ScrollWheelDown>', '<Esc>:call AdjustFonstSize(-1)<CR>a', { silent = true })

keymap('n', '<C-+>', ':call AdjustFontSize(1)<CR>', { silent = true })
keymap('n', '<C-->', ':call AdjustFontSize(-1)<CR>', { silent = true })
keymap('i', '<C-+>', ':call AdjustFontSize(1)<CR>a', { silent = true })
keymap('i', '<C-->', ':call AdjustFontSize(-1)<CR>a', { silent = true })

-- Copy/Paste
keymap('i', '<S-Insert>', '<Esc>"+gPa', { silent = true })
keymap('i', '<M-v>', '<Esc>"+gPa', { silent = true })
keymap('n', '<S-Insert>', '"+gPa', { silent = true })
keymap('n', '<M-v>', '"+gPa', { silent = true })
