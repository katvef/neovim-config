return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		default_mappings = true,
		builtin_marks = { ".", "<", ">", "^", "{", "}" },
		-- whether movements cycle back to the beginning/end of buffer. default true
		cyclic = true,
		force_write_shada = false,
		refresh_interval = 250,
		sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
		excluded_filetypes = {},
		excluded_buftypes = { "quickfix", "acwrite", "nofile" },
		bookmark_0 = {
			sign = "⚑",
			-- virt_text = "hello world",
			annotate = true,
		},
		mappings = {}
	}
}
