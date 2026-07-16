require("flash").setup({
	modes = {
		char = { enabled = false },
		search = { enabled = false },
	},
	jump = {
		autojump = true,
	}
})

vim.keymap.set({ "n", "x", "o" }, "ß", function() require("flash").jump() end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "ẞ", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "n", "x", "o" }, "<C-s>", function() require("flash").treesitter() end, { desc = "Toggle Flash Search" })

vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
