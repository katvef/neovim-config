-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "´"

-- netrw
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
vim.keymap.set("v", "<leader>p", "\"_d<left>p", { desc = "Delete to void and paste" })

-- Copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y")
vim.keymap.set({ "n", "v" }, "<leader>Y", "\"+Y")

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", "\"+p")

-- Paste latest yank
vim.keymap.set("n", "<leader>P", "\"0p")

-- Delete to void
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set({ "n", "v" }, "<leader>D", "\"_D")

-- Centering stuff
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "G", "Gm`10kzz``")

-- Complicated stuff
vim.keymap.set("n", "<leader>sg", ":%s/\\<<C-r><C-w>\\>/<C-r><C-W>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Ctrl+c is esc in visual mode
vim.keymap.set("v", "<C-c>", "<Esc>")

-- Ctrl+arrow enters cmd
vim.keymap.set({ "n", "v" }, "<C-down>", ":")
vim.keymap.set({ "n", "v" }, "<C-up>", ":<up>")

-- Easy access to long distance movement
-- vim.keymap.set("n", "<leader>h", "_")
vim.keymap.set("n", "<leader>l", "$")
vim.keymap.set("n", "<leader>j", "}")
vim.keymap.set("n", "<leader>k", "{")

-- Quick write
vim.keymap.set("n", "<leader>sw", "<cmd>w !sudo tee %<CR>", { desc = "Write with sudo" })
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "Write" })
vim.keymap.set("n", "<leader>ws", function() vim.cmd.w() vim.cmd.so() end, { desc = "Write & source" })

-- Swap comma and semicolon
vim.keymap.set("n", ",", ";")
vim.keymap.set("n", ";", ",")

-- Brackets and quotes
vim.keymap.set("i", "<localleader>(", "(  )<left><left>")
vim.keymap.set("i", "<localleader>[", "[  ]<left><left>")
vim.keymap.set("i", "<localleader>{", "{  }<left><left>")

vim.keymap.set("i", "<localleader>)", "(<CR>)<up><end><CR>")
vim.keymap.set("i", "<localleader>]", "[<CR>]<up><end><CR>")
vim.keymap.set("i", "<localleader>}", "{<CR>}<up><end><CR>")

-- Buffers, windows & tabs
vim.keymap.set("n", "<leader>bd", vim.cmd.bd)
vim.keymap.set("n", "<leader>nv", function() vim.cmd.Vexplore({ bang = true }) end)
vim.keymap.set("n", "<leader>ns", vim.cmd.Sex)

-- Indent whole file
vim.keymap.set("n", "<leader>=",  function() return "m`gg=G``" end, { expr = true })

-- Stay in visual mode when indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Scroll the page easily wihout moving cursor
vim.keymap.set("n", "<M-j>", "<ScrollWheelDown>")
vim.keymap.set("n", "<M-k>", "<ScrollWheelUp>")

-- Shift arrow in insert mode enters visual mode
vim.keymap.set("i", "<S-left>", "<Esc><C-v><C-g><Left>")
vim.keymap.set("i", "<S-down>", "<Right><Esc><C-v><C-g><Down>")
vim.keymap.set("i", "<S-up>", "<Right><Esc><C-v><C-g><Up>")
vim.keymap.set("i", "<S-right>", "<Right><Esc><C-v><C-g><Right>")

-- Insert brackets around selection
vim.keymap.set("v", "<leader>(", "<Esc>`>a)<Esc>`<i(<Esc>gv")
vim.keymap.set("v", "<leader>[", "<Esc>`>a]<Esc>`<i[<Esc>gv")
vim.keymap.set("v", "<leader>{", "<Esc>`>a}<Esc>`<i{<Esc>gv")

-- Insert empty lines above or below using enter
vim.keymap.set("n", "<CS-CR>", "m`O<Esc>0\"_D``")
vim.keymap.set("n", "<C-CR>", "m`o<Esc>0\"_D``")

-- Toggle search highlighting
vim.keymap.set("n", "<C-h>", vim.cmd("set hlsearch!"))

-- Handy insert mode editing shortcuts
vim.keymap.set("i", "", "<C-o>\"_db")
vim.keymap.set("i", "<C-Del>", "<C-o>\"_dw")
vim.keymap.set("i", "<CS-Del>", "<C-o>\"_dw")
vim.keymap.set("i", "<C-d>", "<C-o>diw")
vim.keymap.set("i", "<C-D>", "<C-o>diW")
vim.keymap.set("i", "<C-z>", "<C-o>u")
vim.keymap.set("i", "<C-y>", "<C-o><C-r>")

-- Toggle foldcollumn
vim.keymap.set("n", "<leader>ft", function()
	if vim.o.foldcolumn ~= "0"
		then
			vim.opt.foldcolumn = "0"
			vim.opt.foldenable = false
		else
			vim.opt.foldcolumn = "auto"
			vim.opt.foldenable = true
		end
	end, { desc = "Toggle folds and foldcolumn" } )

	-- Append a character to the end of the line
	vim.keymap.set("n", "<leader>A", function()
		local CurPos = vim.api.nvim_win_get_cursor(0)
		local Char = io.read(1)

		if Char == ""
			then
				vim.cmd.normal{ args = { "A" }, bang = true }
			elseif Char == ""
				then

				else
					vim.cmd("normal! A" .. Char .. "")
				end
				vim.api.nvim_win_set_cursor(0, CurPos)
				Char = ""
			end, { desc = "Append a character to the end of the line" })

			vim.keymap.set("n", "<leader>I", function()
				local CurPos = vim.api.nvim_win_get_cursor(0)
				local Char = io.read(1)

				if Char == ""
					then
						vim.cmd.normal{ args = { "_a" }, bang = true }
					elseif Char == ""
						then

						else
							vim.cmd("normal! I" .. Char .. "")
						end
						vim.api.nvim_win_set_cursor(0, CurPos)
						Char = ""
					end, { desc = "Insert a character to the beginning of the line" })
