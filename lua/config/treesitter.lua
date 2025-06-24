require("nvim-treesitter.configs").setup {
	ensure_installed = { "lua", "markdown", "markdown_inline", "comment" },
	sync_install = false,
	indent = { enable = true },
	install_info = { only_install = true },
	auto_install = true,

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			node_decremental = "grm",
			scope_incremental = "grc",
		},
	},

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.cpp = {
	install_info = {
		url = "/home/elmortti/git/tree-sitter-cpp",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "master",
		generate_requires_npm = true,
		requires_generate_from_grammar = false,
	},
	filetype = "cpp"
}
