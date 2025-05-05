return {
	"catppuccin/nvim",
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "auto",
			background = {
				light = "macchiato",
				dark = "macchiato",
			},

			show_end_of_buffer = true,
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.02,
			},

			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				booleans = { "bold" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				properties = {},
				types = {},
				operators = {},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},

			integrations = {
				aerial = true,
				blink_cmp = true,
				harpoon = true,
				flash = true,
				gitsigns = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				rainbow_delimiters = true,
				which_key = true,
				nvim_surround = true,
				dap = true,

				indent_blankline = {
					enabled = true
				},
				navic = {
					enabled = true,
					custom_bg = "lualine"
				},
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" }
					},
				},
			}
		})
		vim.cmd.colorscheme "catppuccin"
	end
}
