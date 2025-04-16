return {
	{ "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },
	{ "nvim-treesitter/playground",        event = "VeryLazy",  dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "theprimeagen/harpoon",              branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "mbbill/undotree",                   event = "VeryLazy" },
	{ "nvim-lualine/lualine.nvim",         priority = 1000,     dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nanozuki/tabby.nvim",               priority = 1000,     dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "ckolkey/ts-node-action",            event = "VeryLazy",  dependencies = { "nvim-treesitter" }, },
	{ "tpope/vim-fugitive",                event = "VeryLazy",  priority = 1000 },
	{ "lambdalisue/suda.vim",              event = "VeryLazy" },
	{ "neovim/nvim-lspconfig",             event = "VeryLazy",  dependencies = { "saghen/blink.cmp" } },
	{ "SmiteshP/nvim-navic",               event = "VeryLazy",  dependencies = { "neovim/nvim-lspconfig" } },
	{ "linrongbin16/lsp-progress.nvim",    event = "VeryLazy",  config = function() require("lsp-progress").setup() end, },
	{ "andweeb/presence.nvim",             event = "VeryLazy",  config = function() require("presence").setup() end },
	{ "yorickpeterse/nvim-tree-pairs",     event = "VeryLazy",  config = function() require("tree-pairs").setup() end, },
	{ "chentoast/marks.nvim",              event = "VeryLazy" },
	{ "williamboman/mason.nvim",           event = "VeryLazy" },
	{ "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
	{ "mfussenegger/nvim-dap",             event = "VeryLazy" },
	{ 'b0o/incline.nvim',                  event = 'VeryLazy' },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "neovim/nvim-lspconfig", },
	{ "brenoprata10/nvim-highlight-colors" },

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
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme nightfox")
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
		config = function()
			vim.o.winwidth = 15
			vim.o.winminwidth = 15
			vim.o.equalalways = false
			require("windows").setup()
		end
	},

	{
		"yorickpeterse/nvim-window",
		keys = {
			{ "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
		},
		config = true,
	}
}
