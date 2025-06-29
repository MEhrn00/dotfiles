if vim.fn.exists("*fzf#run") == 0 or vim.fn.exists("*fzf#wrap") == 0 then
	return
end

local number_hl = vim.api.nvim_get_hl(0, { name = "Special" })

local ansi_color = string.char(27) .. string.format(
	"[38;2;%d;%d;%dm",
	bit.rshift(number_hl.fg, 16),
	bit.band(bit.rshift(number_hl.fg, 8), 0xff),
	bit.band(number_hl.fg, 0xff)
)

local ansi_reset = string.char(27) .. "[0m"

vim.ui.select = function(items, opts, on_choice)
	local labels = {}
	for i, item in ipairs(items) do
		table.insert(labels, string.format("%s%d.%s %s", ansi_color, i, ansi_reset, opts.format_item(item)))
	end

	if opts.kind ~= nil then
		vim.print(opts.kind)
	end

	local cancel_callback = function()
		on_choice(nil, nil)
	end

	local choice_callback = function(label)
		local period = string.find(label, ".")
		local lnum = tonumber(string.sub(label, 1, period - 1))
		local item = items[lnum]
		on_choice(item, lnum)
	end

	opts = {
		source = labels,
		sink = choice_callback,
		options = table.concat({
			"--reverse",
			"--no-multi",
			"--info=inline-right",
			"--ansi",
			string.format('--prompt="%s "', opts.prompt),
		}, " "),
		window = {
			width = 0.6,
			height = 0.6
		}
	}

	local wrap = vim.fn["fzf#wrap"](opts)
	vim.fn["fzf#run"](wrap)

	vim.api.nvim_create_autocmd("TermClose", {
		once = true,
		buffer = vim.api.nvim_get_current_buf(),
		callback = function()
			if vim.v.event.status ~= 0 then
				cancel_callback()
			end
		end,
	})
end
