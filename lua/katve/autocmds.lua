local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("QuickFixCmdPost", {
	desc = "Automatically open quick fix window on diff",
	group = augroup("AutoOpenQuickfix", { clear = false }),
	pattern = { "[^l]*" },
	command = "cwindow"
})

autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end
})

autocmd("BufEnter", {
	desc = "Disable tabs in .yuck files",
	group = augroup("DisableTabs", { clear = true }),
	callback = function()
		if vim.bo.filetype == "yuck" then
			vim.bo.expandtab = true
			vim.bo.indentexpr = "lispwords"
		end
	end
})

augroup("AutoView", { clear = false })

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
	group = "AutoView",
	callback = function(args)
		if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
	end,
})

autocmd("BufWinEnter", {
	group = "AutoView",
	callback = function(args)
		if not vim.b[args.buf].view_activated then
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
			local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
			local ignore_filetypes = { "gitcommit", "gitrebase", "jjdescription" }
			if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
				vim.b[args.buf].view_activated = true
				vim.cmd.loadview { mods = { emsg_silent = true } }
			end
		end
	end,
})

-- This pair mechanism is tailored specifically for my requirements and is intentionally simple
local char_pairs = {
	{ "(",  ")" },
	{ "{",  "}" },
	{ "[",  "]" },
	{ "<",  ">" },
	{ "\"", "\"" },
	{ "'",  "'" }
}
local open_chars = {}
local close_chars = {}

for _, pair in ipairs(char_pairs) do
	table.insert(open_chars, pair[1])
	table.insert(close_chars, pair[2])
end

local prev_char = nil
local prev_fired = nil

local function handle_next_key(_, typed)
	if typed == "\r" then
		vim.schedule(function() vim.cmd "normal O" end)
	end
	vim.on_key(nil, vim.api.nvim_get_current_buf())
end

vim.api.nvim_create_autocmd("InsertCharPre", {
	group = augroup("AutoPairs", { clear = true }),
	callback = function()
		local char = vim.v.char
		if prev_fired == true then
			prev_fired = false
		else
			for i, open in ipairs(open_chars) do
				if char == open and prev_char == open then
					vim.v.char = close_chars[i]
					vim.schedule(function()
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_win_set_cursor(0, { row, col - 1 })

						vim.on_key(handle_next_key, vim.api.nvim_get_current_buf())
						prev_fired = true
					end)
					break
				end
			end
		end
		prev_char = char
	end,
})
