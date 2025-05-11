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
				fzy_native = {
					fuzzy = true,          -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			}
		})

		require("telescope").load_extension("aerial")
		require("telescope").load_extension("fzy_native")

		local function map(lhs, rhs, opts, mode)
			mode = mode or "n"
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		local builtin = require("telescope.builtin")
		local theme = require("telescope.themes")

		map("<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		map("<leader>fr", builtin.git_files, { desc = "Telescope git files" })
		map("<leader>fp", function() builtin.find_files(theme.get_dropdown()) end, { desc = "Telescope find files" })
		map("<leader>fg", function() builtin.live_grep(theme.get_dropdown()) end, { desc = "Telescope live grep" })
		map("<leader>fb", function() builtin.buffers(theme.get_dropdown()) end, { desc = "Telescope buffers" })
		map("<leader>ft", function() builtin.treesitter(theme.get_dropdown()) end, { desc = "Telescope treesitter" })
		map("<leader>fj", builtin.jumplist, { desc = "Telescope jump list" })
		map("<leader>fo", builtin.grep_string, { desc = "Telescope grep string" })
		map("<leader>fs", builtin.oldfiles, { desc = "Telescope file history" })
		map("<leader>fh", builtin.current_buffer_fuzzy_find, { desc = "Telescope fuzzy search" })
		map("<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope fuzzy search" })
		map("<C-p>", builtin.git_files, { desc = "Telescope git files" })
	end,
	-- tag = "0.1.8"
}
