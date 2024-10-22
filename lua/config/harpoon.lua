local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-c>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-p>", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<M-5>", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<M-6>", function() harpoon:list():select(6) end)
vim.keymap.set("n", "<M-7>", function() harpoon:list():select(7) end)
vim.keymap.set("n", "<M-8>", function() harpoon:list():select(8) end)
vim.keymap.set("n", "<M-9>", function() harpoon:list():select(9) end)
vim.keymap.set("n", "<M-0>", function() harpoon:list():select(0) end)

-- vim.keymap.set("n", "<M-j>", function() harpoon:list():select(function() print(vim.v.count + 0) end) end, { expr = true })
-- vim.keymap.set("n", "<M-j>", function() print(vim.v.count) end, { expr = true })

vim.keymap.set("n", "<SM-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<SM-n>", function() harpoon:list():next() end)
