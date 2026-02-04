local wk = require("which-key")
wk.add({
	{ "<leader>f",  group = "file" },
	{ "<leader>w",  proxy = "<c-w>", group = "windows" },
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
	}
})
