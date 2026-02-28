require("katve.functions")
require("katve.lazy")


require("katve.katpack").setup({
	configs = "config",
	async_build = true,
	auto_delete = true,
	auto_update = true,
	confirm = { install = false, update = false, delete = true },
	prefer_config_file = true,
})

require("katve.katpack").add({
	"gh:atiladefreitas/dooing",
	"gh:danymat/neogen",
	"gh:williamboman/mason.nvim",
	"gh:brenoprata10/nvim-highlight-colors",
	"gh:stevearc/conform.nvim",
	"gh:mfussenegger/nvim-lint",
	"gh:NeogitOrg/neogit",
	"gh:nvim-mini/mini.icons",
	"gh:HiPhish/rainbow-delimiters.nvim"
})

require("katve")
require("config")
ColorMyPencils()
