return {
	{ "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },
	{ "nvim-treesitter/playground",        event = "VeryLazy", dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "theprimeagen/harpoon",              event = "VeryLazy", branch = "harpoon2",                                     dependencies = { "nvim-lua/plenary.nvim" } },
	{ "mbbill/undotree",                   event = "VeryLazy" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "nvim-lualine/lualine.nvim",         priority = 1000,    dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nanozuki/tabby.nvim",               priority = 1000,    dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "neovim/nvim-lspconfig", },
	{ "ckolkey/ts-node-action",            event = "VeryLazy", dependencies = { "nvim-treesitter" }, },
	{ "tpope/vim-fugitive",                event = "VeryLazy", priority = 1000 },
	{ "brenoprata10/nvim-highlight-colors" },
	{ "lambdalisue/suda.vim",              event = "VeryLazy" },
	-- { "saadparwaiz1/cmp_luasnip" },
	-- { "hrsh7th/cmp-nvim-lsp" },
	-- { "hrsh7th/cmp-buffer" },
	-- { "hrsh7th/cmp-path" },
	-- { "hrsh7th/cmp-cmdline" },
	-- { "hrsh7th/nvim-cmp" },
	{ "neovim/nvim-lspconfig",             event = "VeryLazy", dependencies = { "saghen/blink.cmp" } },
	{ "linrongbin16/lsp-progress.nvim",    event = "VeryLazy", config = function() require("lsp-progress").setup() end, },
	{ "yorickpeterse/nvim-tree-pairs",     event = "VeryLazy", config = function() require("tree-pairs").setup() end, },
	{ "andweeb/presence.nvim", config = function() require("presence").setup() end },

	{
		"nvim-telescope/telescope.nvim",
		config = { function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
			vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy search' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		end },
		tag = "0.1.8"
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
