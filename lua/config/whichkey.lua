local wk = require("which-key")
wk.add({
	{ "<leader>f",  group = "file" },                                   -- group
	{ "<leader>fn", desc = "New File" },
	{ "<leader>w",  proxy = "<c-w>",  group = "windows" },              -- proxy to window mappings
	{
		"<leader>b",
		group = "buffers",
		expand = function()
			return require("which-key.extras").expand.buf()
		end
	},
	{
		-- Nested mappings are allowed and can be added in any order
		-- Most attributes can be inherited or overridden on any level
		-- There's no limit to the depth of nesting
		mode = { "n", "v" }, -- NORMAL and VISUAL mode
		-- I wan't no easy way to quit or I'll wuit accidentally
		-- { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
		-- { "<leader>w", "<cmd>w<cr>", desc = "Write" },
	}
})
