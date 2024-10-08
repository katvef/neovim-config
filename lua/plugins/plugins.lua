return {
	{ "EdenEast/nightfox.nvim", priority = 1000, config = function() vim.cmd("colorscheme nightfox") end, },
	{ "nvim-treesitter/nvim-treesitter", build  = ":TSUpdate" },
	{ "nvim-treesitter/playground" },
	{ "theprimeagen/harpoon" },
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "freddiehaddad/feline.nvim" },
	{ "nanozuki/tabby.nvim",
		-- event = 'VimEnter', -- if you want lazy load, see below
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			-- configs...
		end,
	},
}
