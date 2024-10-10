local theme = {
	fill = 'TabLineFill',
	head = 'TabLine',
	current_tab = 'TabLineSel',
	tab = 'TabLine',
	win = 'TabLine',
	tail = 'TabLine',
	separator = '',
}
require('tabby').setup({
	preset = 'active_wins_at_end',
	line = function(line)
		return {
			{
			},
			line.tabs().foreach(function(tab)
				return {
					tab.is_current() and {
						{ '   ', tab.name(), ' ', line.sep('', theme.head, theme.fill) },
					},
					hl = theme.head,
				}
			end),
			-- List tabs
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and theme.current_tab or theme.tab
				local winCount = 0
				return {
					line.sep('', hl, theme.fill),
					{ ' ', hl = hl },
					tab.number(),
					{ '[', winCount, '] ' },
					tab.is_current() and {
						line.sep('', hl, theme.fill) or line.sep('', hl, theme.fill),
						line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
							local hl2 = win.is_current() and theme.current_tab or theme.tab
							return {
								line.sep('', hl2, theme.fill),
								win.buf_name(),
								line.sep('', hl2, theme.fill),
								hl = hl2,
								margin = ' ',
							}
						end),
						{
							{
								line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
									return {
										win.is_current() and {
											line.sep('', theme.win, theme.fill),
											win.file_icon(),
											win.is_current() and line.sep('', theme.win, theme.fill),
											margin = ' ',
										},
										hl = theme.win,
									}
								end),
							},
						},
					} or line.sep('', hl, theme.fill),
					hl = hl,
					margin = '',
				}
			end),

			-- Close button
			-- line.tabs().foreach(function(tab)
				-- 	return {
					-- 		{
						-- 			line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
							-- 				return {
								-- 				win.is_current() and tab.is_current() and line.sep('', theme.current_tab, theme.fill),
								-- 				win.is_current() and tab.is_current() and tab.close_btn(' 󰱞 '),
								-- 				win.is_current() and tab.is_current() and win.is_current() and line.sep('', theme.current_tab, theme.fill),
								-- 					hl = theme.current_tab,
								-- 				}
								-- 			end),
								-- 		},
								-- 	}
								-- end),
								{  },
								line.spacer(),
								{
									line.sep('', theme.tail, theme.fill),
									{ '  ', hl = theme.tail },
								},
								hl = theme.fill,
							}
						end,
						-- option = {}, -- setup modules' option,
					})

					-- Remaps

					vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>:Ex<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
					vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
