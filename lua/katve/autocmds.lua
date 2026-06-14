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

augroup("AutoView", { clear = false })

vim.opt.viewoptions = { "folds", "cursor" }
vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions:remove("cursor")

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
	{ "(", ")" },
	{ "{", "}" },
	{ "[", "]" },
	{ "<", ">" },
	{ '"', '"' },
	{ "'", "'" },
	{ "`", "`" },
}

for _, pair in ipairs(char_pairs) do
	vim.keymap.set("i", "<localleader>" .. pair[1], pair[1] .. "  " .. pair[2] .. "<left><left>")
	if pair[1] ~= pair[2] then
		vim.keymap.set("i", "<localleader>" .. pair[2], pair[1] .. "\n" .. pair[2] .. "<up><end>\n")
	end
end

local dash_ns = vim.api.nvim_create_namespace("empty_line_dashes")
local ibl_ns = vim.api.nvim_get_namespaces()["indent_blankline"]
vim.api.nvim_set_hl(0, "EmptyLineDash", { fg = BrightenColor(HighlightToHex("Normal", "bg"), 1.8) })

local function IblAffectsLine(buf, line)
	if not ibl_ns then return false end
	return #(vim.api.nvim_buf_get_extmarks(buf, ibl_ns, { line, 0 }, { line, -1 }, {})) > 0
end

autocmd({ "BufEnter", "TextChanged", "TextChangedI", "WinResized" }, {
	callback = function()
		vim.api.nvim_buf_clear_namespace(0, dash_ns, 0, -1)
		local dashline = string.rep("-", vim.api.nvim_win_get_width(0))

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for i = 1, #lines do
			local prev = lines[i - 1] or ""
			local next = lines[i + 1] or ""
			if prev ~= "" or next ~= "" then
				if lines[i]:match("^%s*$") and not IblAffectsLine(0, i - 1) then
					vim.api.nvim_buf_set_extmark(0, dash_ns, i - 1, 0, {
						virt_text = { { dashline, "EmptyLineDash" } },
						virt_text_pos = "eol",
						hl_mode = "combine"
					})
				end
			end
		end
	end
})

autocmd("FileType", { callback = function() vim.opt_local.formatoptions = "jql" end, })

-- Ensure alternate screen is left on exit
vim.api.nvim_create_autocmd('VimLeave', { callback = function() io.write('\27[?1049l') end })
