return {
	{
		"echasnovski/mini.bracketed",
		version = "*",
		config = function()
			require("mini.bracketed").setup()
		end
	},

	{
		"echasnovski/mini.files",
		version = false,
		config = function()
			local mini_files = require("mini.files")
			mini_files.setup({
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
			vim.keymap.set("n", "<leader>pe", function() mini_files.open() end)
			vim.keymap.set("n", "<C-n>", function() mini_files.open() end)
		end,
	},
}
