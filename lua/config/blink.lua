require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "mono" },
	sources = { default = { "lsp", "snippets", "buffer", "path" } },

	completion = {
		documentation = { auto_show = true },
		keyword = { range = "full" },
		menu = {
			auto_show = function () return vim.lsp.buf_is_attached() end,
			draw = { treesitter = { "lsp" } },
		},
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
		},
		list = {
			selection = {
				preselect = true,
				auto_insert = true
			}
		},
		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_without_selection = true,
			show_with_menu = true,
			show_without_menu = true
		},
	},

	signature = {
		enabled = true,
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
		},
		window = { show_documentation = false }
	},
})
