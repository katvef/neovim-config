return {
	"nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			extensions = {
				aerial = {
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
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				}
			}
		})

		require("telescope").load_extension("aerial")
		require("telescope").load_extension("possession")
		require("telescope").load_extension("fzy_native")

		local function map(lhs, rhs, opts, mode)
			mode = mode or "n"
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		local builtin = require("telescope.builtin")
		local extension = require("telescope").extensions
		local theme = require("telescope.themes")

		map("<leader>ff", function() builtin.fd({ no_ignore = true, hidden = true }) end, { desc = "Telescope find files" })
		map("<leader>fp", function() builtin.fd(theme.get_dropdown(), { no_ignore = true }) end,
			{ desc = "Telescope find files" })
		map("<leader>fr", function() builtin.git_files({ hidden = true }) end, { desc = "Telescope git files" })
		map("<leader>fg", function() builtin.live_grep(theme.get_dropdown()) end, { desc = "Telescope live grep" })
		map("<leader>fb", function() builtin.buffers(theme.get_dropdown()) end, { desc = "Telescope buffers" })
		map("<leader>ft", function() builtin.treesitter(theme.get_dropdown()) end, { desc = "Telescope treesitter" })
		map("<leader>fa", function() extension.aerial.aerial(theme.get_dropdown()) end, { desc = "Telescope aerial" })
		map("<leader>fS", function() extension.possession.possession(theme.get_dropdown()) end,
			{ desc = "Telescope aerial" })
		map("<leader>fj", builtin.jumplist, { desc = "Telescope jump list" })
		map("<leader>fo", builtin.grep_string, { desc = "Telescope grep string" })
		map("<leader>fs", builtin.oldfiles, { desc = "Telescope file history" })
		map("<leader>fh", builtin.current_buffer_fuzzy_find, { desc = "Telescope fuzzy search" })
		map("<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Telescope fuzzy search" })
		map("<C-p>", builtin.git_files, { desc = "Telescope git files" })
	end,
	-- tag = "0.1.8"
}
