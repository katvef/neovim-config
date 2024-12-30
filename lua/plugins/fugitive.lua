return {
	vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git" }),
	vim.keymap.set("n", "<leader>gsf", "<cmd>Git fetch<CR>", { desc = "Git fetch" }),
	vim.keymap.set("n", "<leader>gsd", "<cmd>Git diff<CR>", { desc = "Git fetch" }),
	vim.keymap.set("n", "<leader>gsC", "<cmd>Git commit<CR>", { desc = "Git commit" }),
	vim.keymap.set("n", "<leader>gsc", "<cmd>Git checkout<CR>", { desc = "Git checkout" }),
	vim.keymap.set("n", "<leader>gsp", "<cmd>Git pull<CR>", { desc = "Git pull" }),
	vim.keymap.set("n", "<leader>gsP", "<cmd>Git push<CR>", {  desc = "Git push" }),
	vim.keymap.set("n", "<leader>gw", "<cmd>Gw<CR>", { desc = "Git write" }),
	vim.keymap.set("n", "<leader>gsA", "<cmd>Git add .<CR>", { desc = "Git write" }),
	vim.keymap.set("n", "<leader>gsa", function()
		local input = vim.fn.input("Git files to add: ")
		vim.cmd.Git{ args = { "add " .. input } }
	end, { desc = "Add git files" }),
}
