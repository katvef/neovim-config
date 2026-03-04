require("katve.katpack").add {
	{ src = "gh:nvim-treesitter/nvim-treesitter", build = ":TSUpdate",                                dependencies = { "gh:OXY2DEV/markview.nvim" } },
	{ src = "gh:nanozuki/tabby.nvim",             dependencies = { "gh:nvim-tree/nvim-web-devicons" } },
	{ src = "gh:theprimeagen/harpoon",            branch = "harpoon2",                                dependencies = { "gh:nvim-lua/plenary.nvim" } },
	{ src = "gh:esmuellert/codediff.nvim",        dependencies = { "gh:MunifTanjim/nui.nvim" } },
	{ src = "gh:SmiteshP/nvim-navic",             dependencies = { "gh:neovim/nvim-lspconfig" } },
	{ src = "gh:yorickpeterse/nvim-tree-pairs",   opts = {} },
	{ src = "gh:aserowy/tmux.nvim",               opts = {} },
	{ src = "gh:b0o/incline.nvim", },
	{ src = "gh:lambdalisue/suda.vim", },
	{ src = "gh:mfussenegger/nvim-dap", },
	{ src = "gh:danymat/neogen",                  opts = {} },
	{ src = "gh:williamboman/mason.nvim",         opts = {} },

	{
		src = "gh:ptdewey/pendulum-nvim",
		branch = "v2",
		build = ":PendulumRebuild",
		opts = {
			log_file = vim.env.HOME .. "/.pendulum-log.csv",
			timeout_len = 300,
			timer_len = 120,
			gen_reports = true,
			top_n = 5,
			hours_n = 10,
			time_format = "24h",
			time_zone = "Finland/Helsinki",
			report_excludes = {
				branch = { "unknown_branch" },
				directory = {},
				file = {},
				filetype = {},
				project = { "unknown_project" },
			},
			report_section_excludes = {},
		}
	},

	{
		src = "gh:rachartier/tiny-code-action.nvim",
		event = "LspAttach",
		dependencies = { "gh:nvim-lua/plenary.nvim", "gh:nvim-telescope/telescope.nvim" },
		opts = {},
	},

	{
		src = "gh:neovim/nvim-lspconfig",
		dependencies = { "gh:saghen/blink.cmp" },
	},

	{
		src = "gh:mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
			vim.keymap.set("n", "<leader>U", function()
				vim.cmd.UndotreeToggle()
				vim.cmd.UndotreeFocus()
			end)
		end,
	},

	{
		src = "gh:numToStr/Comment.nvim",
		opts = {
			padding = true,
			sticky = true,
			ignore = "^$",
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
		},
	},

	{
		src = "gh:ckolkey/ts-node-action",
		dependencies = { "gh:nvim-treesitter/nvim-treesitter" },
		config = function()
			vim.keymap.set("n", "ö", require("ts-node-action").node_action)
			vim.keymap.set("i", "<C-ö>", require("ts-node-action").node_action)
		end,
	},

	{
		src = "gh:nvim-telescope/telescope-fzy-native.nvim",
		dependencies = { {
			src = "gh:romgrk/fzy-lua-native",
			build = "make",
		} },
	},

	{
		src = "gh:stevearc/aerial.nvim",
		dependencies = { "gh:nvim-treesitter/nvim-treesitter", "gh:nvim-tree/nvim-web-devicons" },
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "<leader>{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "<leader>}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},

	{
		src = "gh:L3MON4D3/LuaSnip",
		dependencies = { "gh:rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
	},

	{
		src = "gh:Saghen/blink.cmp",
		dependencies = { "gh:rafamadriz/friendly-snippets", },
		version = vim.version.range("v1.*"),
		build = "cargo build --release",
		async_build = false
	},

	{
		src = "gh:nvim-mini/mini.ai",
		config = function()
			require("mini.ai").setup({
				n_lines = 50,
				search_method = "cover_or_next",
				silent = false,
				custom_textobjects = { ["”"] = { "“().*()”" } },

				mappings = {
					around = "a",
					inside = "i",

					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					goto_left = "g[",
					goto_right = "g]",
				},
			})
		end,
	},

	{
		src = "gh:nvim-mini/mini.surround",
		config = function()
			require("mini.surround").setup({
				custom_surroundings = { ["”"] = { input = { "“().-()”" }, output = { left = "“", right = "”" } } },
				n_lines = 20,
				respect_selection_type = true,
				search_method = "cover",
				silent = false,
				highlight_duration = 1000,

				mappings = {
					add = "sa",
					delete = "ds",
					find = "sf",
					find_left = "sF",
					highlight = "sh",
					replace = "sr",
					update_n_lines = "sn",

					suffix_last = "l",
					suffix_next = "n",
				},
			})
		end,
	},

	{
		src = "gh:anuvyklack/animation.nvim",
		dependencies = { "gh:anuvyklack/middleclass" },
		config = function()
			local Animation = require("animation")
			local duration = 50 -- ms
			local fps = 60 -- frames per second
			local easing = require("animation.easing")
			local i = 0
			local function callback(fraction)
				i = i + 1
			end
			local animation = Animation(duration, fps, easing.line, callback)
			animation:run()
		end,
	},

	{
		src = "gh:anuvyklack/windows.nvim",
		dependencies = { "gh:anuvyklack/middleclass", "gh:anuvyklack/animation.nvim" },
		config = function()
			vim.o.winwidth = 15
			vim.o.winminwidth = 15
			vim.o.equalalways = false
			require("windows").setup({
				ignore = {
					buftype = { "nofile", "quickfix" },
					filetype = { "undotree", "aerial", "diff", "gitcommit", "git" },
				},
			})
		end,
	},
}
