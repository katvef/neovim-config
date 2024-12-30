return {
	{
		"echasnovski/mini.comment", version = false,
		config = function()
			require("mini.comment").setup()
		end
	},

	{
		"echasnovski/mini.bracketed", version = "*",
		config = function()
			require("mini.bracketed").setup()
		end
	},

	{
		"echasnovski/mini.files", version = false,
		config = function()
			require("mini.files").setup({
					-- Customization of shown content
					content = {
						-- Predicate for which file system entries to show
						filter = nil,
						-- What prefix to show to the left of file system entry
						prefix = nil,
						-- In which order to show file system entries
						sort = nil,
					},

					-- Module mappings created only inside explorer.
					-- Use `''` (empty string) to not create one.
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

					-- General options
					options = {
						-- Whether to delete permanently or move into module-specific trash
						permanent_delete = true,
						-- Whether to use for editing directories
						use_as_default_explorer = true,
					},

					-- Customization of explorer windows
					windows = {
						-- Maximum number of windows to show side by side
						max_number = math.huge,
						-- Whether to show preview of file/directory under cursor
						preview = true,
						-- Width of focused window
						width_focus = 50,
						-- Width of non-focused window
						width_nofocus = 15,
						-- Width of preview window
						width_preview = 40,
					},
			})
		end,
		vim.keymap.set("n", "<leader>pe", function() MiniFiles.open() end),
		vim.keymap.set("n", "<C-n>", function() MiniFiles.open() end),
	},
}
