require("conform").setup({
	formatters_by_ft = {
		-- lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "biome-check" },
		typescript = { "biome-check" },
		yaml = { "yamlfix" },
		sh = { "shfmt" },
		gdscript = { "gdformat" },
		cs = { "clang-format" },
		cpp = { "clang-format" },
		qml = { "qmlformat6" },
	},

	formatters = {
		qmlformat6 = {
			meta = {
				url = "https://doc.qt.io/qt-6//qtqml-tooling-qmlformat.html",
				description = "A tool that automatically formats QML files.",
			},
			command = "/usr/lib/qt6/bin/qmlformat",
			args = { "-i", "$FILENAME" },
			stdin = false,
		}
	}
})
