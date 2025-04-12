vim.o.showtabline = 2

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

	option = {
		tab_name = {
			name_fallback = function()
				return ''
			end
		}
	},

	line = function(line)
		local winsInTab = line.wins_in_tab(line.api.get_current_tab())
		return {

			-- Header
			line.tabs().foreach(function(tab)
				return {
					tab.is_current() and {
						'  ', line.sep('', theme.head, theme.fill)
					},
					hl = theme.head,
				}
			end),

			-- Tabs
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and theme.current_tab or theme.tab
				local winCount = #vim.api.nvim_tabpage_list_wins(vim.api.nvim_list_tabpages()[tab.number()])
				return {
					line.sep('', hl, theme.fill),
					{
						tab.number(),
						winCount > 1 and { '[', winCount, ']' }
					},
					tab.name(),
					line.sep('', hl, theme.fill),
					hl = hl,
					margin = ' ',
				}
			end),

			line.spacer(),

			-- Windows in tab
			winsInTab.foreach(function(win)
				return {
					line.sep('', theme.win, theme.fill),
					win.buf_name(),
					line.sep('', theme.win, theme.fill),
					margin = ' ',
					hl = theme.win
				}
			end),

			-- Tail
			{
				line.sep('', theme.tail, theme.fill),
				{ '  ', hl = theme.tail },
			},

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

vim.keymap.set("n", "<leader>tr", function()
	local tabName = vim.fn.input("Tab name: ")
	if tabName == '' then
		print("Rename aborted")
	else
		vim.cmd.TabRename { args = { tabName } }
		print("Renamed tab to " .. tabName)
	end
end)
