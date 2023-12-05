-- Setup up DAP debugger
local dapui = require('dapui')
local dap = require('dap')
require('dap-go').setup()
require('dap-python').setup("/usr/bin/python")
require("nvim-dap-virtual-text").setup()
require('telescope').load_extension('dap')

-- Debug adapters
dap.adapters.lldb = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
}

-- Language configurations for DAP
dap.configurations.c = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        args = {},
        runInTerminal = false,
    },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

dap.configurations.go = {
    {
        name = "Debug",
        type = "go",
        request = "launch",
        program = "${file}",
    },
}

-- Debug UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup()

keymap("n", "<F3>", ":lua require'dapui'.toggle()<CR>")
keymap("n", "<F4>", ":lua require'dap'.terminate()<CR>")
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>")
keymap("n", "<F6>", ":lua require'dap'.step_over()<CR>")
keymap("n", "<F7>", ":lua require'dap'.step_into()<CR>")
keymap("n", "<F8>", ":lua require'dap'.step_out()<CR>")
keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
keymap("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
keymap("v", "<M-k>", ":lua require'dapui'.eval()<CR>")
