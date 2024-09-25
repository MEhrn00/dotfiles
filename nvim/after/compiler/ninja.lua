-- Compiler plugin for Ninja

local errorformats = {
	"%D%*\\a[%*\\d]: Entering directory %*[`']%f'",
	"%X%*\\a[%*\\d]: Leaving directory %*[`']%f'",
	"%D%*\\a: Entering directory %*[`']%f'",
	"%X%*\\a: Leaving directory %*[`']%f'",
}

for _, fmt in ipairs(errorformats) do
	if not vim.list_contains(vim.opt_local.errorformat:get(), fmt) then
		vim.opt_local.errorformat:append(fmt)
	end
end

vim.opt_local.makeprg = "ninja"
