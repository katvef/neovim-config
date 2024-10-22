return {
	vim.keymap.set("n", "<leader>gs", vim.cmd.Git),
	vim.keymap.set("n", "<leader>gsf", "<cmd>Git fetch<CR>"),
	vim.keymap.set("n", "<leader>gsd", "<cmd>Git diff<CR>"),
	vim.keymap.set("n", "<leader>gsc", "<cmd>Git commit<CR>"),
	vim.keymap.set("n", "<leader>gsp", "<cmd>Git pull<CR>"),
	vim.keymap.set("n", "<leader>gsP", "<cmd>Git push<CR>"),
	vim.keymap.set("n", "<leader>gsa", function()
		local input = vim.fn.input("Git files to add: ")
		vim.cmd.Git{ args = { "add " .. input } }
	end),
}
