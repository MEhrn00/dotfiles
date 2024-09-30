-- Compiler plugin for Ninja

local errorformats = {
	'%*[^"]"%f"%*\\D%l: %m',
	'"%f"%*\\D%l: %m',
	"%-G%f:%l: (Each undeclared identifier is reported only once",
	"%-G%f:%l: for each function it appears in.)",
	"%-GIn file included from %f:%l:%c:",
	"%-GIn file included from %f:%l:%c\\",
	"",
	"%-GIn file included from %f:%l:%c",
	"%-GIn file included from %f:%l",
	"%-G%*[ ]from %f:%l:%c",
	"%-G%*[ ]from %f:%l:",
	"%-G%*[ ]from %f:%l\\",
	"",
	"%-G%*[ ]from %f:%l",
	"%f:%l:%c: %trror: %m",
	"%f:%l:%c: %tarning: %m",
	"%f(%l): %trror: %m",
	"%f(%l): %tarning: %m",
	"%f:%l:%c:%m",
	"%f(%l):%m",
	"%f:%l:%m",
	'"%f"\\',
	" line %l%*\\D%c%*[^ ] %m",
	"%D%*\\a[%*\\d]: Entering directory %*[`']%f'",
	"%X%*\\a[%*\\d]: Leaving directory %*[`']%f'",
	"%D%*\\a: Entering directory %*[`']%f'",
	"%X%*\\a: Leaving directory %*[`']%f'",
	"%f|%l| %m",
}

vim.opt_local.errorformat = vim.iter(errorformats):join(",")
