return {
	"nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			extensions = {
				aerial = {
					-- Set the width of the first two columns (the second
					-- is relevant only when show_columns is set to 'both')
					col1_width = 4,
					col2_width = 30,
					-- How to format the symbols
					format_symbol = function(symbol_path, filetype)
						if filetype == "json" or filetype == "yaml" then
							return table.concat(symbol_path, ".")
						else
							return symbol_path[#symbol_path]
						end
					end,
					-- Available modes: symbols, lines, both
					show_columns = "both",
				},
			}
		})
		require("telescope").load_extension("aerial")
		local builtin = require("telescope.builtin")
		local theme = require("telescope.themes")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>pf', function() builtin.find_files(theme.get_dropdown()) end, { desc = 'Telescope find files' })
		vim.keymap.set("n", "<leader>fg", function() builtin.live_grep(theme.get_dropdown()) end, { desc = 'Telescope live grep' })
		vim.keymap.set("n", "<leader>fb", function() builtin.buffers(theme.get_dropdown()) end, { desc = 'Telescope buffers' })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy search' })
		vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' })
		vim.keymap.set('n', '<leader>ps', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
	end,
	tag = "0.1.8"
}
