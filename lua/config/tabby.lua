vim.o.showtabline = 2

local tab_name = require("tabby.feature.tab_name")

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

-- Functions
local function rename_tab(args)
	local tab = args.tabid or 0
	local tabname = args.tabname
	if tabname:sub(1, 1) == "%" then
		local mods = tabname:sub(2, 2) ~= "" and tabname:sub(2) or ":t:r"
		local newname = vim.fn.fnamemodify(vim.fn.expand("%"), mods)
		tab_name.set(tab, newname)
		print("renamed tab to " .. newname)
	elseif tabname:match("^%s*$") then
		tab_name.set(tab)
		print("removed tab name")
	else
		tab_name.set(tab, tabname)
		print("renamed tab to " .. tabname)
	end
end

-- Commands
vim.api.nvim_create_user_command("RenameTab", function(args)
	rename_tab({ tabname = args.args })
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
end, { desc = "Rename all tab" })
vim.keymap.set("n", "<leader>tR", function()
	local tabName = vim.fn.input({ prompt = "Tab name: ", cancelreturn = vim.NIL })
	if tabName == vim.NIL then
		return
	else
		for _, tab in ipairs(require("tabby.module.api").get_tabs()) do
			rename_tab({ tabid = tab, tabname = tabName })
		end
	end
end, { desc = "Rename all tabs" })
