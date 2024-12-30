-- Automatically open quick fix window on diff
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = false }),
	pattern = { "[^l]*" },
	command = "cwindow",
})
