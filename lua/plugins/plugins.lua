return {
	{ "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },
	{ "theprimeagen/harpoon",              branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/playground",        event = "VeryLazy",  dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "nvim-lualine/lualine.nvim",         priority = 1000,     dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nanozuki/tabby.nvim",               priority = 1000,     dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "EdenEast/nightfox.nvim",            priority = 1000,     config = function() vim.cmd("colorscheme nightfox") end },
	{ "neovim/nvim-lspconfig",             event = "VeryLazy",  dependencies = { "saghen/blink.cmp" } },
	{ "SmiteshP/nvim-navic",               event = "VeryLazy",  dependencies = { "neovim/nvim-lspconfig" } },
	{ "linrongbin16/lsp-progress.nvim",    event = "VeryLazy",  config = function() require("lsp-progress").setup() end, },
	{ "andweeb/presence.nvim",             event = "VeryLazy",  config = function() require("presence").setup() end },
	{ "yorickpeterse/nvim-tree-pairs",     event = "VeryLazy",  config = function() require("tree-pairs").setup() end, },
	{ 'b0o/incline.nvim',                  event = 'VeryLazy' },
	{ "mbbill/undotree",                   event = "VeryLazy" },
	{ "tpope/vim-fugitive",                priority = 1000 },
	{ "chentoast/marks.nvim",              lazy = true },
	{ "williamboman/mason.nvim",           lazy = true },
	{ "williamboman/mason-lspconfig.nvim", lazy = true },
	{ "mfussenegger/nvim-dap",             lazy = true },
	{ "lambdalisue/suda.vim",              lazy = true },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "neovim/nvim-lspconfig", },
	{ "brenoprata10/nvim-highlight-colors" },

	{
		"ckolkey/ts-node-action",
		lazy = true,
		dependencies = { "nvim-treesitter" },
	},
	{ "nvim-telescope/telescope-fzy-native.nvim", dependencies = { "romgrk/fzy-lua-native", build = "make" } },

	{
		'stevearc/aerial.nvim',
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
			vim.keymap.set("n", "<leader>q", "<cmd>AerialToggle!<CR>")
		end
	},

	{
		"andweeb/presence.nvim",
		config = function() require("presence").setup() end
	},

	{
		"aserowy/tmux.nvim",
		event = "VeryLazy",
		config = function() return require("tmux").setup() end
	},

	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		dependencies = { "rafamadriz/friendly-snippets" },
		priority = 1000,
		version = "v2.*",
		build = "make install_jsregexp"
	},

	{
		"Saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		build = "cargo build --release",
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("nvim-surround").setup({
				aliases = {
					["a"] = ">",
					["p"] = ")",
					["b"] = "}",
					["r"] = "]",
					["q"] = { '"', "'", "`" },
					["B"] = { "}", "]]", "]", ")", ">" },
					["s"] = { "}", "]]", "]", ")", ">", '"', "'", "`" },
				},
				vim.keymap.set("o", "i.", function() vim.cmd("normal T.vt.") end)
			})
		end
	},

	{
		"anuvyklack/animation.nvim",
		dependencies = { "anuvyklack/middleclass" },
		config = function()
			local Animation = require("animation")
			local duration = 100 -- ms
			local fps = 60 -- frames per second
			local easing = require("animation.easing")
			local i = 0
			local function callback(fraction)
				i = i + 1
				print('frame ', i)
			end
			local animation = Animation(duration, fps, easing.line, callback)
			animation:run()
		end
	},

	{
		"anuvyklack/windows.nvim",
		dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
		event = "VeryLazy",
		lazy = true,
		config = function()
			vim.o.winwidth = 15
			vim.o.winminwidth = 15
			vim.o.equalalways = false
			require("windows").setup({
				ignore = {
					buftype = { "quickfix" },
					filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "aerial", "diff", "gitcommit", "git" }
				}
			})
		end
	}
}
