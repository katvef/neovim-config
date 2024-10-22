return {
	vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle),
	vim.keymap.set("n", "<leader>U", function() vim.cmd.UndotreeToggle() vim.cmd.UndotreeFocus() end)
}
