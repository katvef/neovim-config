return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		local neogit = require('neogit').open
		local function wrap(func, opts) return function() func(opts) end end

		vim.keymap.set("n", "<leader>gs", wrap(neogit, { kind = "floating" }), { desc = "Neogit" })
		vim.keymap.set("n", "<leader>gs", wrap(neogit, { kind = "floating" }), { desc = "Neogit" })
		vim.keymap.set("n", "<leader>gsf", wrap(neogit, { "fetch" }), { desc = "Neogit fetch" })
		vim.keymap.set("n", "<leader>gsd", wrap(neogit, { "diff" }), { desc = "Neogit diff" })
		vim.keymap.set("n", "<leader>gsc", wrap(neogit, { "commit" }), { desc = "Neogit commit" })
		vim.keymap.set("n", "<leader>gsp", wrap(neogit, { "pull" }), { desc = "Neogit pull" })
		vim.keymap.set("n", "<leader>gsP", wrap(neogit, { "push" }), { desc = "Neogit push" })
		vim.keymap.set("n", "<leader>gw", "<cmd>w<CR><cmd>!git add %<CR>", { desc = "Git write" })

		vim.keymap.set("n", "<leader>gsa", function()
				local input = vim.ui.input({ prompt = "Git files to add: " },
					function(input) vim.cmd("!git add " .. input) end)
			end,
			{ desc = "Add git files" })

		vim.keymap.set("n", "<leader>gsb", "<cmd>Git blame<CR>", { desc = "Git blame" })
		vim.keymap.set("n", "<leader>gsB", function()
			local input = vim.fn.input("Commit: ")
			vim.cmd.Git { args = { "add " .. input } }
		end, { desc = "Git blame specific commit" })
	end
}
