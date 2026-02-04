require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "biome-check" },
		yaml = { "yamlfix" },
		sh = { "beautysh" }
	},
})
