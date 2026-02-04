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
