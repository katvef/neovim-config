require("katve.functions")
require("katve.lazy")


require("katve.katpack").setup({
	configs = "config",
	async_build = true,
	auto_delete = true,
	auto_update = false,
	confirm = { install = false, update = false },
	prefer_config_file = true,
})

require("katve.katpack").add({
	{ src = "gh:atiladefreitas/dooing", config = function() require("dooing").setup() end },
	{ src = "gh:NeogitOrg/neogit",      config = function() require("neogit").setup() end },
	"gh:danymat/neogen",
	"gh:williamboman/mason.nvim",
	"gh:brenoprata10/nvim-highlight-colors",
	"gh:stevearc/conform.nvim",
	"gh:mfussenegger/nvim-lint",
	"gh:nvim-mini/mini.icons",
	"gh:HiPhish/rainbow-delimiters.nvim"
})

require("katve")
require("config")
ColorMyPencils()
