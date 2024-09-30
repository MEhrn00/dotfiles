-- TODO: Move to nvim plugin
local M = {}

local defaultexcludes = {
	"Cargo.lock",
	"go.mod",
	"go.sum",
}

local function extractGitConfigExcludes(path)
	local fp = io.open(path, "r")
	if fp then
		local content = fp:read("*a")
		fp:close()

		local excludesFile = content:match("excludesFile = ([%w%p]+)")
		if excludesFile ~= nil then
			return excludesFile
		end
	end

	return nil
end

-- Function for generating a ctags file
local function ctags()
	local excludefiles = {}

	local gitconfigpaths = {
		".git/config",
		vim.env.HOME .. "/.config/git/config",
		vim.env.HOME .. "/.gitconfig",
		"/etc/gitconfig",
	}

	for _, p in ipairs(gitconfigpaths) do
		local gitexclude = extractGitConfigExcludes(p)
		if gitexclude ~= nil then
			table.insert(excludefiles, gitexclude)
		end
	end

	local fp = io.open(".gitignore", "r")
	if fp ~= nil then
		fp:close()
		table.insert(excludefiles, ".gitignore")
	end

	fp = io.open(".ctagsignore", "r")
	if fp ~= nil then
		fp:close()
		table.insert(excludefiles, ".ctagsignore")
	end

	fp = io.open(vim.env.HOME .. "/.config/git/ignore", "r")
	if fp ~= nil then
		fp:close()
		table.insert(excludefiles, vim.env.HOME .. "/.config/git/ignore")
	end

	local ctagsExcludesArguments = ""
	for _, exclude in ipairs(defaultexcludes) do
		ctagsExcludesArguments = ctagsExcludesArguments .. string.format("--exclude='%s' ", exclude)
	end

	for _, f in ipairs(excludefiles) do
		ctagsExcludesArguments = ctagsExcludesArguments .. string.format("--exclude='@%s' ", f)
	end

	local tagsUpdated = false
	local tagsFile = io.open("tags", "r")
	if tagsFile then
		tagsUpdated = true
		tagsFile:close()
	end

	local ctagsCommand = "ctags -R " .. ctagsExcludesArguments .. "." .. " 2>&1"
	local handle = io.popen(ctagsCommand)

	if handle ~= nil then
		local output = handle:read("*a")
		local rc = handle:close()

		if rc == nil then
			print(output)
		elseif not tagsUpdated then
			print("Tags file generated")
		end
	else
		vim.print("Failed to run ctags")
	end
end

function M.setup()
	-- Create ctags command
	vim.api.nvim_create_user_command("Ctags", ctags, {
		nargs = "?",
		desc = "Run ctags",
	})
end

return M
