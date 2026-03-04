vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Local Keymaps (which-key)" })
require("katve.katpack").add {
	{
		src = "gh:folke/which-key.nvim",
		opts = {
			plugins = {
				marks = true,
				registers = true,
				spelling = {
					enabled = true,
					suggestions = 20,
				},
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},
		},
	}
}
