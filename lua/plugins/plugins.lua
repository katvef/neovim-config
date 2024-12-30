return {
	{ "nvim-treesitter/nvim-treesitter", build  = ":TSUpdate" },
	{ "nvim-treesitter/playground", dependencies = { "nvim-treesitter/nvim-treesitter"  } },
	{ "theprimeagen/harpoon", event = "VeryLazy", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "mbbill/undotree", event = "VeryLazy" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "nanozuki/tabby.nvim", priority = 1000, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nvim-lualine/lualine.nvim", priority = 1000, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nanozuki/tabby.nvim", priority = 1000, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "linrongbin16/lsp-progress.nvim", config = function() require("lsp-progress").setup() end, },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip", priority = 1000, version = "v2.*", build = "make install_jsregexp" },
	{ "saadparwaiz1/cmp_luasnip", priority = 999 },
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8" },
	{ "ckolkey/ts-node-action", dependencies = { "nvim-treesitter" }, },
	{ "tpope/vim-fugitive", priority = 1000 },
	{ "brenoprata10/nvim-highlight-colors"  },
	{ "yorickpeterse/nvim-tree-pairs", config = function() require("tree-pairs").setup() end, },

	{ "kylechui/nvim-surround",
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
				["B"] = { "}", "]", ")", ">" },
				["s"] = { "}", "]", ")", ">", '"', "'", "`" },
			},
		})
	end },

	{ "EdenEast/nightfox.nvim", priority = 1000,
	config = function()
		vim.cmd("colorscheme nightfox")
	end },

	{ "anuvyklack/animation.nvim", dependencies = { "anuvyklack/middleclass" },
	config = function ()
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
	end },

	{ "anuvyklack/windows.nvim",
	event = "VeryLazy",
	config = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false
		require("windows").setup()
	end },

	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},

	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		config = function()
			require("window-picker").setup()
		end,
	},
}
