local autocmd = vim.api.nvim_create_autocmd
local autogrp = vim.api.nvim_create_augroup

autocmd("QuickFixCmdPost", {
	desc = "Automatically open quick fix window on diff",
	group = autogrp("AutoOpenQuickfix", { clear = false }),
	pattern = { "[^l]*" },
	command = "cwindow"
})

autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = autogrp("HighlightYank", { clear = true }),
	callback = function ()
		vim.highlight.on_yank()
	end
})

autocmd("BufEnter", {
	desc = "Disable tabs in .yuck files",
	group = autogrp("DisableTabs", { clear = true }),
	callback = function ()
		if vim.bo.filetype == "yuck" then
			vim.bo.expandtab = true
			vim.bo.indentexpr = "lispwords"
		end
	end
})
