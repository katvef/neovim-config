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
local char_pairs_map = {}

for _, pair in ipairs(char_pairs) do
	char_pairs_map[pair[1]] = pair[2]
end

local prev_char = nil
local prev_fired = nil


local function handle_next_key(_, typed)
	if typed == "\r" then
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
		local before_cursor = line:sub(0, col)
		local after_cursor = (line:match("^%s*") or "") .. line:sub(col + 1)
		vim.api.nvim_buf_set_lines(0, row - 1, row, false, { before_cursor, after_cursor })
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
			for open, close in pairs(char_pairs_map) do
				if char == open and prev_char == open then
					vim.v.char = close
					vim.schedule(function()
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_win_set_cursor(0, { row, col - 1 })
					end)
					vim.on_key(handle_next_key, vim.api.nvim_get_current_buf())
					prev_fired = true
					break
				end
			end
		end
		prev_char = char
	end,
})
