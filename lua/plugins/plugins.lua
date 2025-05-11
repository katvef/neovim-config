return {
	{ "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },
	{ "theprimeagen/harpoon",              branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/playground",        event = "VeryLazy",  dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "nanozuki/tabby.nvim",               priority = 1000,     dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "EdenEast/nightfox.nvim",            priority = 1000 },
	{ "neovim/nvim-lspconfig",             event = "VeryLazy",  dependencies = { "saghen/blink.cmp" } },
	{ "linrongbin16/lsp-progress.nvim",    event = "VeryLazy",  config = function() require("lsp-progress").setup() end, },
	{ "andweeb/presence.nvim",             event = "VeryLazy",  config = function() require("presence").setup() end },
	{ "yorickpeterse/nvim-tree-pairs",     event = "VeryLazy",  config = function() require("tree-pairs").setup() end, },
	{ 'b0o/incline.nvim',                  event = "VeryLazy" },
	{ "lambdalisue/suda.vim",              event = "VeryLazy" },
	{ "SmiteshP/nvim-navic",               lazy = true,         dependencies = { "neovim/nvim-lspconfig" } },
	{ "williamboman/mason.nvim",           config = function() require("mason").setup() end },
	{ "mfussenegger/nvim-dap",             lazy = true },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{ "neovim/nvim-lspconfig", },
	{ "brenoprata10/nvim-highlight-colors" },
	{ "xzbdmw/colorful-menu.nvim" },

	{
		"mbbill/undotree",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
			vim.keymap.set("n", "<leader>U", function()
				vim.cmd.UndotreeToggle()
				vim.cmd.UndotreeFocus()
			end)
		end
	},

	{
		"numToStr/Comment.nvim",
		lazy = true,
		keys = { "gc", "gb" },
		opts = {
			padding = true,
			sticky = true,
			ignore = '^$',
			toggler = {
				line = 'gcc',
				block = 'gbc',
			},
			opleader = {
				line = 'gc',
				block = 'gb',
			},
			extra = {
				above = 'gcO',
				below = 'gco',
				eol = 'gcA',
			},
			mappings = {
				basic = true,
				extra = true,
			},
		}
	},

	{
		"ckolkey/ts-node-action",
		lazy = true,
		keys = { "ö", "<C-ö>" },
		dependencies = { "nvim-treesitter" },
		config = function()
			vim.keymap.set("n", "ö", require("ts-node-action").node_action)
			vim.keymap.set("i", "<C-ö>", require("ts-node-action").node_action)
		end
	},

	{ "nvim-telescope/telescope-fzy-native.nvim", dependencies = { "romgrk/fzy-lua-native", build = "make" } },

	{
		'stevearc/aerial.nvim',
		event = "VeryLazy",
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
		-- version = "v2.*",
		build = "make install_jsregexp"
	},

	{
		"Saghen/blink.cmp",
		event = "VeryLazy",
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
					["B"] = { "}", "]", ")", ">" },
					["s"] = { "}", "]", ")", ">", '"', "'", "`" },
				},
				vim.keymap.set("o", "i.", function() vim.cmd("normal T.vt.") end),
				vim.keymap.set("o", "a.", function() vim.cmd("normal F.vf.") end),
				vim.keymap.set("o", "i,", function() vim.cmd("normal T,vt,") end),
				vim.keymap.set("o", "a,", function() vim.cmd("normal F,vf,") end),
				vim.keymap.set("o", "i_", function() vim.cmd("normal T_vt_") end),
				vim.keymap.set("o", "a_", function() vim.cmd("normal F_vf_") end),
			})
		end
	},

	{
		"anuvyklack/animation.nvim",
		event = "VeryLazy",
		dependencies = { "anuvyklack/middleclass" },
		config = function()
			local Animation = require("animation")
			local duration = 100 -- ms
			local fps = 60 -- frames per second
			local easing = require("animation.easing")
			local i = 0
			local function callback(fraction)
				i = i + 1
				-- print('frame ', i)
			end
			local animation = Animation(duration, fps, easing.line, callback)
			animation:run()
		end
	},

	{
		"anuvyklack/windows.nvim",
		event = "VeryLazy",
		dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
		-- event = "VeryLazy",
		lazy = true,
		config = function()
			vim.o.winwidth = 15
			vim.o.winminwidth = 15
			vim.o.equalalways = false
			require("windows").setup({
				ignore = {
					buftype = { "nofile", "quickfix" },
					filetype = { "undotree", "aerial", "diff", "gitcommit", "git" }
				}
			})
		end
	}
}
