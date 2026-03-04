require("katve.katpack").add { {
	src = "gh:folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		{ src = "gh:ibhagwan/fzf-lua", dependencies = { "gh:nvim-mini/mini.icons" } },
		"gh:MunifTanjim/nui.nvim"
	},
	opts = {
		lsp = {
			signature = {
				enabled = false
			}
		}
	}
} }
