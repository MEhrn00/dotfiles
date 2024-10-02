-- Compiler plugin for Ninja

local errorformats = {
	"%f(%l): %tarning: %m",
	"%f(%l): %trror: %m",
	"%f:%l:%c: %tarning: %m",
	"%f:%l:%c: %trror: %m",
}

for _, fmt in ipairs(vim.opt_local.errorformat:get()) do
	if not vim.list_contains(errorformats, fmt) then
		table.insert(errorformats, fmt)
	end
end

for _, fmt in ipairs(errorformats) do
	if not vim.list_contains(vim.opt_local.errorformat:get(), fmt) then
		-- vim.opt_local.errorformat:prepend(fmt)
	end
end
