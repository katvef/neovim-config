local oil = require("oil")

oil.setup({
	columns = {
		"permissions",
		"size",
		"icon",
	},

	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
		number = false,
		relativenumber = false,
	},

	buf_options = {
		buflisted = true,
		bufhidden = "delete",
	},

	float = {
		padding = 2,
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│", },
		win_options = { winblend = 0, },
		preview_split = "right",
	},

	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["J"] = { "actions.preview_scroll_down", mode = "n" },
		["L"] = { "actions.preview_scroll_right", mode = "n" },
		["K"] = { "actions.preview_scroll_up", mode = "n" },
		["H"] = { "actions.preview_scroll_left", mode = "n" },
		["q"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},

	skip_confirm_for_simple_edits = true,
})

vim.keymap.set("n", "<C-b>",
	function() oil.toggle_float(vim.fn.getcwd(), nil, require("oil.actions").preview.callback) end)
vim.keymap.set("n", "<leader>ep", function() oil.toggle_float(nil, nil, require("oil.actions").preview.callback) end)

vim.keymap.set("n", "<leader>er", function()
	vim.ui.input({
		prompt = "Enter uri: ",
	}, function(input)
		if input == nil or input == "" then return end
		oil.toggle_float(input, nil, require("oil.actions").preview.callback)
	end)
end)
