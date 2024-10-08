return {
	{ "EdenEast/nightfox.nvim", priority = 1000, config = function() vim.cmd("colorscheme nightfox") end, },
	{ "nvim-treesitter/nvim-treesitter", build  = ":TSUpdate" },
	{ "nvim-treesitter/playground" },
	{ "theprimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },
	{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "nanozuki/tabby.nvim", priority = 1000, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nvim-lualine/lualine.nvim", priority = 1000, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "nanozuki/tabby.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "linrongbin16/lsp-progress.nvim", config = function() require("lsp-progress").setup() end, },
	{ "HiPhish/rainbow-delimiters.nvim" }
}
