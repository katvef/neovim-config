return {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
		require('nightfox').setup({
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath("cache") .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = false,   -- Disable setting background
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = true,   -- Non focused panes set to alternative background
				module_default = true, -- Default enable value for modules
				colorblind = {
					enable = false,    -- Enable colorblind support
					simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
					severity = {
						protan = 0,    -- Severity [0,1] for protan (red)
						deutan = 0,    -- Severity [0,1] for deutan (green)
						tritan = 0,    -- Severity [0,1] for tritan (blue)
					},
				},
				styles = { -- Style to be applied to different syntax groups
					comments = "italic", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "italic",
					constants = "bold,underline",
					functions = "underdashed",
					keywords = "italic",
					numbers = "NONE",
					operators = "bold",
					strings = "NONE",
					types = "italic",
					variables = "NONE",
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				modules = { -- List of various plugins and additional options
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
							errors = { "undercurl", "bold" },
							hints = { "underline" },
							warnings = { "undercurl" },
							information = { "underline" }
						},
					},
				},
			},
			palettes = {},
			specs = {},
			groups = {},
		})

		-- setup must be called before loading
		vim.cmd.colorscheme "nightfox"
	end
}
