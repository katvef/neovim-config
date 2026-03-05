local function cmd(command) return '<Cmd>' .. command .. '<CR>' end
vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize')
vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically')
vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally')
vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize')
vim.o.winwidth = 15
vim.o.winminwidth = 15
vim.o.equalalways = false

require("windows").setup({
	ignore = {
		buftype = { "nofile", "quickfix" },
		filetype = { "undotree", "aerial", "diff", "gitcommit", "git" },
	},
})
