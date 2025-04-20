local autocmd = vim.api.nvim_create_autocmd
local autogrp = vim.api.nvim_create_augroup

autocmd("QuickFixCmdPost", {
	desc = "Automatically open quick fix window on diff",
	group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = false }),
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
