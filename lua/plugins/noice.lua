return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "ibhagwan/fzf-lua", dependencies = { "nvim-mini/mini.icons" } },
		"MunifTanjim/nui.nvim"
	},
	opts = {
		lsp = {
			signature = {
				enabled = false
			}
		}
	}
}
