function HighlightToHex(hl, prop)
	return string.format("#%x", vim.api.nvim_get_hl(0, { name = hl, link = false })[prop])
end

-- Set custom colors for theme
function ColorMyPencils()
	vim.api.nvim_set_hl(0, "cursorline", { bg = "#1b293b" })
	vim.api.nvim_set_hl(0, "cursorcolumn", { bg = "#1b293b" })
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = HighlightToHex("TabLine", "bg") })
end

ColorMyPencils()
vim.api.nvim_create_user_command("ColorMyPencils", "lua ColorMyPencils()", { bang = true })
