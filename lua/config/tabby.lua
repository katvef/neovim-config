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
				return nil
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
						'  ', line.sep('', theme.head, theme.fill)
					},
					hl = theme.head,
				}
			end),

			-- Tabs
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and theme.current_tab or theme.tab
				local winCount = #line.api.get_tab_wins(tab.id)
				return {
					line.sep(tab.is_current() and '' or '', hl, theme.fill),
					tab.name() or tab.id,
					{
						-- winCount > 1 and { '[', winCount, ']' }
					},
					line.sep('', hl, theme.fill),
					hl = hl,
					margin = ' ',
				}
			end),

			line.spacer(),

			-- Windows in tab
			winsInTab.foreach(function(win)
				local hl = win.is_current() and theme.current_tab or theme.tab
				return {
					line.sep('', hl, theme.fill),
					win.buf_name(),
					win.buf().id,
					line.sep('', hl, theme.fill),
					margin = ' ',
					hl = hl
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

-- Kehmaps
vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>:Ex<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })

vim.keymap.set("n", "<leader>tr", function()
	local tabName = vim.fn.input("Tab name: ")
	if tabName:match("^%s*$") then
		vim.cmd.Tabby { args = { "rename_tab" } }
		print("Removed tab name")
	else
		vim.cmd.Tabby { args = { "rename_tab", tabName } }
		print("Renamed tab to " .. tabName)
	end
end)
