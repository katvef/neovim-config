return {
	"catppuccin/nvim",
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = {   -- :h background
				light = "macchiato",
				dark = "macchiato",
			},

			show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.05, -- percentage of the shade to apply to the inactive window
			},

			no_italic = false,  -- Force no italic
			no_bold = false,    -- Force no bold
			no_underline = false, -- Force no underline
			styles = {          -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
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
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				mason = true,
				markdown = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" }
					},
				},

				navic = { enabled = true, custom_bg = "lualine" },
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				rainbow_delimiters = true,
				which_key = true,
				nvim_surround = true,
				dap = true
			}
		})
		vim.cmd.colorscheme "catppuccin"
	end
}
