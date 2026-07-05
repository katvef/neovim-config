require("mini.surround").setup({
	custom_surroundings = { ["”"] = { input = { "“().-()”" }, output = { left = "“", right = "”" } } },
	n_lines = 100,
	respect_selection_type = true,
	search_method = "cover",
	silent = false,
	highlight_duration = 1000,

	mappings = {
		add = "sa",
		delete = "ds",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",

		suffix_last = "l",
		suffix_next = "n",
	},
})

require("mini.ai").setup({
	n_lines = 50,
	search_method = "cover_or_next",
	silent = false,
	custom_textobjects = { ["”"] = { "“().*()”" } },

	mappings = {
		around = "a",
		inside = "i",

		around_next = "an",
		inside_next = "in",
		around_last = "al",
		inside_last = "il",

		goto_left = "g[",
		goto_right = "g]",
	},
})

vim.keymap.set("n", "<C-n>", function() require("mini.files").open() end)
