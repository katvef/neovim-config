return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		default_mappings = true,
		builtin_marks = { ".", "<", ">", "^", "{", "}" },
		-- whether movements cycle back to the beginning/end of buffer. default true
		cyclic = true,
		force_write_shada = true,
		refresh_interval = 150,
		-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
		-- marks, and bookmarks.
		-- can be either a table with all/none of the keys, or a single number, in which case
		-- the priority applies to all marks.
		-- default 10.
		sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
		-- disables mark tracking for specific filetypes. default {}
		excluded_filetypes = { "nofile", "diff" },
		-- disables mark tracking for specific buftypes. default {}
		excluded_buftypes = { "quickfix" },
		-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
		-- sign/virttext. Bookmarks can be used to group together positions and quickly move
		-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
		-- default virt_text is "".
		bookmark_0 = {
			sign = "⚑",
			-- virt_text = "hello world",
			annotate = true,
		},
		mappings = {}
	}
}
