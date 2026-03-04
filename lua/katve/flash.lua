vim.keymap.set({ "n", "x", "o" }, "<M-C-s>", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "š", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "ß", function() require("flash").jump() end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "<M-C-S-s>", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "n", "x", "o" }, "Š", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "n", "x", "o" }, "ẞ", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set({ "o", "x" }, "<C-r>", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set("n", "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

require("katve.katpack").add {
	{
		src = "gh:folke/flash.nvim",
		opts = {
			modes = {
				char = { enabled = false }
			},
			jump = {
				autojump = true,
			}
		}
	}
}
