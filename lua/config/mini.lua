require("mini.files").setup({
	content = {
		-- Predicate for which file system entries to show
		filter = nil,
		-- What prefix to show to the left of file system entry
		prefix = nil,
		-- In which order to show file system entries
		sort = nil,
	},

	mappings = {
		close = 'q',
		go_in = 'l',
		go_in_plus = 'L',
		go_out = 'h',
		go_out_plus = 'H',
		mark_goto = "'",
		mark_set = 'm',
		reset = '<BS>',
		reveal_cwd = '@',
		show_help = 'g?',
		synchronize = 'Y',
		trim_left = '<',
		trim_right = '>',
	},

	options = {
		permanent_delete = true,
		use_as_default_explorer = false, -- Causes annoying issues with the popup opening when not wanted
	},

	windows = {
		max_number = math.huge,
		preview = true,
		width_focus = 50,
		width_nofocus = 15,
		width_preview = 40,
	},
})

require("mini.surround").setup({
	custom_surroundings = { ["”"] = { input = { "“().-()”" }, output = { left = "“", right = "”" } } },
	n_lines = 20,
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

vim.keymap.set("n", "<leader>pe", function() require("mini.files").open() end)
vim.keymap.set("n", "<C-n>", function() require("mini.files").open() end)
