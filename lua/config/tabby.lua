vim.o.showtabline = 2

local theme = {
	fill = "TabLineFill",
	head = "TabLine",
	current_tab = "TabLineSel",
	tab = "TabLine",
	win = "TabLine",
	tail = "TabLine",
	separator = "",
}

require("tabby").setup({
	preset = "active_wins_at_end",

	option = {
		tab_name = {
			name_fallback = function(tabid)
				local winid = require("tabby.module.api").get_tab_current_win(tabid)
				local bufid = vim.api.nvim_win_get_buf(winid)
				return tostring(bufid)
			end,
		},
	},

	line = function(line)
		local winsInTab = line.wins_in_tab(line.api.get_current_tab())
		return {

			-- Header
			line.tabs().foreach(function(tab)
				return {
					tab.is_current() and {
						"  ",
						line.sep("", theme.head, theme.fill),
					},
					hl = theme.head,
				}
			end),

			-- Tabs
			line.tabs().foreach(function(tab)
				local hl = tab.is_current() and theme.current_tab or theme.tab
				local name = tab.name()
				local wins = tab.wins()
				local win_icons = ""
				wins.foreach(function(win)
					win_icons = win_icons .. " " .. win.buf().id .. "/" .. win.file_icon()
				end)
				win_icons = win_icons:sub(2)
				return {
					line.sep(tab.is_current() and "" or "", hl, theme.fill),
					tab.in_jump_mode() and tab.jump_key(),
					tab.current_win().buf().id == name and win_icons or {
						name and name .. "/" .. tab.current_win().file_icon() or win_icons
					},
					line.sep("", hl, theme.fill),
					hl = hl,
					margin = " ",
				}
			end),

			line.spacer(),

			-- Windows in tab
			winsInTab.foreach(function(win)
				local hl = win.is_current() and theme.current_tab or theme.tab
				return {
					line.sep("", hl, theme.fill),
					win.buf_name(),
					line.sep("", hl, theme.fill),
					margin = " ",
					hl = hl,
				}
			end),

			-- Tail
			{
				line.sep("", theme.tail, theme.fill),
				{ vim.fn.fnamemodify(vim.uv.cwd(), ":~"), hl = theme.tail },
			},
		}
	end,
	-- option = {}, -- setup modules' option,
})

-- Commands
vim.api.nvim_create_user_command("RenameTab", function(args)
	local tabName = args.args
	if tabName:sub(1, 1) == "%" then
		local mods = tabName:sub(2, 2) ~= "" and tabName:sub(2) or ":t:r"
		local newName = vim.fn.fnamemodify(vim.fn.expand("%"), mods)
		vim.cmd.Tabby({ args = { "rename_tab", newName } })
		print("Renamed tab to " .. newName)
	elseif tabName:match("^%s*$") then
		vim.cmd.Tabby({ args = { "rename_tab" } })
		print("Removed tab name")
	else
		vim.cmd.Tabby({ args = { "rename_tab", tabName } })
		print("Renamed tab to " .. tabName)
	end
end, { desc = "Rename current tab, use %<mods> to use modified filename", nargs = "*" })

-- Kehmaps
vim.keymap.set("n", "<leader>ta", ":$tabnew<CR>:Ex<CR>")
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")
vim.keymap.set("n", "gmt", ":-tabmove<CR>")
vim.keymap.set("n", "gmT", ":+tabmove<CR>")
vim.keymap.set("n", "<leader>ts", ":tabn #<CR>")
vim.keymap.set("n", "<leader>tj", ":Tabby jump_to_tab<CR>")
vim.keymap.set("n", "<leader>tr", function()
	local tabName = vim.fn.input({ prompt = "Tab name: ", cancelreturn = vim.NIL })
	if tabName == vim.NIL then
		return
	elseif tabName:match("^%s*$") then
		vim.cmd.RenameTab()
	else
		vim.cmd.RenameTab({ args = { tabName } })
	end
end)
