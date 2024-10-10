return {
	vim.keymap.set("n", "GS", vim.cmd.Git),
	-- Extra fugitive binds
	vim.keymap.set("n", "GF", ":Git fetch<CR>"),
	vim.keymap.set("n", "GD", ":Git diff<CR>"),
	vim.keymap.set("n", "GD", ":Git commit<CR>"),
	vim.keymap.set("n", "GP", ":Git pull<CR>"),
	vim.keymap.set("n", "Gp", ":Git push<CR>"),
}
