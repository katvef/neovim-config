local theme = {
	fill = 'TabLineFill',
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = 'TabLine',
	current_tab = 'TabLineSel',
	tab = 'TabLine',
	win = 'TabLine',
	tail = 'TabLine',
}
require('tabby').setup({
	preset = 'active_wins_at_end',
	line = function(line)
		return {
			{
				{ '  ', hl = theme.head },
				line.sep('', theme.head, theme.fill),
			},
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and theme.current_tab or theme.tab
				return {
					line.sep('', hl, theme.fill),
					tab.number(),
					tab.close_btn(),
					line.sep('', hl, theme.fill),
					hl = hl,
					margin = ' ',
				}
			end),
			{
				{
					line.tabs().foreach(function(tab)
						return {
							tab.is_current() and line.sep('', theme.win, theme.fill),
							tab.is_current() and tab.name(),
							hl = theme.win,
							margin = ' ',
						}
					end)
				},
				{ ' ', hl = theme.win },
				{
					line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
						return {
							win.is_current() and win.file_icon(),
							win.is_current() and line.sep('', theme.win, theme.fill),
							hl = theme.win,
							margin = ' ',
						}
					end),
				}
			},

			line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
				local hl = win.is_current() and theme.current_tab or theme.tab
				return {
					line.sep('', hl, theme.fill),
					win.buf_name(),
					line.sep('', hl, theme.fill),
					hl = hl,
					margin = ' ',
				}
			end),
			line.spacer(),
			{
				line.sep('', theme.tail, theme.fill),
				{ '  ', hl = theme.tail },
			},
			hl = theme.fill,
		}
	end,
	-- option = {}, -- setup modules' option,
})

-- Remaps
vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
