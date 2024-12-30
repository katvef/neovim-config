local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<M-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<M-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<M-c>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<M-p>", function() harpoon:list():select(4) end)

-- Generate keymaps for Alt+Number to jump to relevant entry in harpoon
for i = 1, 9 do
vim.keymap.set("n", "<M-" .. i .. ">", function() harpoon:list():select(i) end)
end

-- vim.keymap.set("n", "<M-j>", function() harpoon:list():select(function() print(vim.v.count + 0) end) end, { expr = true })
-- vim.keymap.set("n", "<M-j>", function() print(vim.v.count) end, { expr = true })

vim.keymap.set("n", "<SM-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<SM-n>", function() harpoon:list():next() end)
