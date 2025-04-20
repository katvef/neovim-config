vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '⍽', extends = '→', multispace = '.·' }
vim.opt.colorcolumn = "100"

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.signcolumn = 'yes'

vim.opt.virtualedit = "onemore"

vim.opt.spr = true

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.foldtext = "v:lua.HighlightedFoldtext()"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

vim.opt.fileformats = "unix"
vim.opt.fileformat = "unix"

vim.opt.splitright = true
vim.opt.splitbelow = true
