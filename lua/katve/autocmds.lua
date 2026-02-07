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

local generate_binds = true

if generate_binds then
	for _, pair in ipairs(char_pairs) do
		vim.keymap.set("i", "<localleader>" .. pair[1], pair[1] .. "  " .. pair[2] .. "<left><left>")
		if pair[1] ~= pair[2] then
			vim.keymap.set("i", "<localleader>" .. pair[2], pair[1] .. "\n" .. pair[2] .. "<up><end>\n")
		end
	end
end

local prev_char = nil
local prev_fired = nil
local prev_open = nil
local prev_row, prev_col = unpack(vim.api.nvim_win_get_cursor(0))

local function handle_next_key(_, typed)
	if typed == "\r" then
		local line = vim.api.nvim_buf_get_lines(0, prev_row - 1, prev_row, false)[1]
		local before_cursor = line:sub(0, prev_col)
		local after_cursor = (line:match("^%s*") or "") .. line:sub(prev_col + 1)
		vim.api.nvim_buf_set_lines(0, prev_row - 1, prev_row, false, { before_cursor, after_cursor })
	elseif typed == vim.api.nvim_replace_termcodes("<BS>", true, false, true) then
		vim.api.nvim_win_set_cursor(0, { prev_row, prev_col + 1 })
		vim.schedule_wrap(vim.api.nvim_put)({ prev_char }, "c", true, true)
	elseif typed == " " then
		vim.api.nvim_buf_set_text(0, prev_row, prev_col, prev_row, prev_col, {prev_open})
	end

	vim.on_key(nil, vim.api.nvim_get_current_buf())
end

autocmd("InsertCharPre", {
	group = augroup("CustomAutoPairs", { clear = true }),
	callback = function()
		local char = vim.v.char
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local lines = vim.api.nvim_buf_get_lines(0, prev_row - 1, prev_row, false)
		local last_line = lines[1]
		local last_char = ""

		if last_line ~= nil and #last_line or 0 >= prev_col + 1 then
			last_char = last_line:sub(prev_col + 1, prev_col + 1)
		end

		if prev_fired == true then
			prev_fired = false
		elseif row == prev_row and col == prev_col + 1 then
			for open, close in pairs(char_pairs_map) do
				if char == open and prev_char == open and char == last_char then
					vim.v.char = ""
					vim.schedule(function()
						vim.api.nvim_win_set_cursor(0, { row, col - 1 })
						vim.api.nvim_put({ close }, "c", true, false)
					end)
					vim.on_key(handle_next_key, vim.api.nvim_get_current_buf())
					prev_open = open
					prev_fired = true
					break
				end
			end
		end

		prev_char = char
		prev_row = row
		prev_col = col
	end,
})
