-- Leader
vim.g.mapleader = " "
vim.g.mapinsertleader = "´"

-- netRw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move lines up and down in visual select mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Centering stuff
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Delete to void and paste
vim.keymap.set("x", "<leader>p", "\"_dp")

-- Copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y")
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y")
vim.keymap.set({ "n", "v" }, "<leader>P", "\"+p")

-- Delete to void
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set({ "n", "v" }, "<leader>D", "\"_D")
vim.keymap.set({ "n", "v" }, "<leader>dd", "\"_dd")

-- Centering stuff
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Complicated stuff
vim.keymap.set("n", "<leader>sg", ":%s/\\<<C-r><C-w>\\>/<C-r><C-W>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Exit insert on double j
vim.keymap.set("i", "jj", "<Esc>")

-- Block arrow keys for movement
vim.keymap.set("n", "<left>", function() print "use h to move left" end)
vim.keymap.set("n", "<right>", function() print "use l to move right" end)
vim.keymap.set("n", "<up>", function() print "use k to move left" end)
vim.keymap.set("n", "<down>", function() print "use j to move left" end)

-- Ctrl+arrow enters cmd
vim.keymap.set({ "n", "v" }, "<C-down>", ":<down>")
vim.keymap.set({ "n", "v" }, "<C-up>", ":<up>")

-- Easy access to long distance movement
vim.keymap.set("n", "<leader>h", "_")
vim.keymap.set("n", "<leader>l", "$")
vim.keymap.set("n", "<leader>j", "}")
vim.keymap.set("n", "<leader>k", "{")

-- Quick write
vim.keymap.set("n", "<leader>sw", ":w !sudo dd of=%<CR>")
vim.keymap.set("n", "<leader>ww", ":w<CR>")
vim.keymap.set("n", "<leader>ws", ":w<CR>:so<CR>")

-- Swap comma and semicolon
vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ",")

-- Brackets & Braces auto format
vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "{", "{}<left>")
	-- Double brackets are normal, so you can easily just type them with nothing inside
vim.keymap.set("i", "()", "()")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "{}", "{}")

vim.keymap.set("i", "<insertleader>(", "(<CR>)<up><CR>")
vim.keymap.set("i", "<insertleader>[", "[<CR>]<up><CR>")
vim.keymap.set("i", "<insertleader>{", "{<CR>}<up><CR>")

vim.keymap.set("i", "<insertleader>)", "(<CR>)<up><CR>")
vim.keymap.set("i", "<insertleader>]", "[<CR>]<up><CR>")
vim.keymap.set("i", "<insertleader>}", "{<CR>}<up><CR>")

-- vim.keymap.set("n", "<leader>op", "<Esc><C-v>a%")

-- Buffers, windows & tabs
vim.keymap.set("n", "<leader>bd", vim.cmd.bd)
vim.keymap.set("n", "<leader>t", ":tabnew<CR>:Ex<CR>")
vim.keymap.set("n", "<leader>nv", "<C-w>v<C-w><C-w>:Ex<CR>")
vim.keymap.set("n", "<leader>ns", "<C-w>s<C-w><C-w>:Ex<CR>")

-- Format whole file
vim.keymap.set("n", "<leader>=", "jgg=G<C-o>kzz")

-- Stay in visual mode when indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
