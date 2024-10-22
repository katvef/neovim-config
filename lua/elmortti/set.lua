vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.undodir = "./undo"
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "

vim.opt.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '⍽', extends = '→', multispace = '  +'}

vim.opt.colorcolumn = "120"

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.spr = true

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.foldtext = "v:lua.HighlightedFoldtext()"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = false }),
	pattern = { "[^l]*" },
	command = "cwindow",
})
