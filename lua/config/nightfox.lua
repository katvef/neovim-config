require('nightfox').setup({
	options = {
		compile_path = vim.fn.stdpath("cache") .. "/nightfox",
		compile_file_suffix = "_compiled",
		transparent = false,
		terminal_colors = false,
		dim_inactive = true,
		module_default = true,
		styles = {
			comments = "italic",
			conditionals = "italic",
			constants = "bold,italic",
			functions = "bold",
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
		modules = {

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
					errors = "undercurl,bold",
					hints = "underline",
					warnings = "undercurl",
					information = "underdashed"
				},
			},
		},
	},
	palettes = {},
	specs = {
		nightfox = {
			syntax = {
				field = "NONE",
				func = "NONE",
				bracket = "orange.dim",
				string = "green.bright",
				builtin0 = "red"
			}
		}
	},
	groups = {},
})

-- setup must be called before loading
vim.cmd.colorscheme "nightfox"
