local capabilities = require("blink.cmp").get_lsp_capabilities()
local lspconfig = require("lspconfig")

vim.diagnostic.config({ virtual_text = true })

vim.api.nvim_create_autocmd("LspAttach", {
	-- desc = "LSP actions",
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("K", vim.lsp.buf.hover, "Show hover")
		map("gd", vim.lsp.buf.definition, "Goto definition")
		map("gD", vim.lsp.buf.declaration, "Goto declaration")
		map("gi", vim.lsp.buf.implementation, "Goto implementation")
		map("go", vim.lsp.buf.type_definition, "Goto type definition")
		map("gr", vim.lsp.buf.references, "Goto references")
		map("gs", vim.lsp.buf.signature_help, "Signature help")
		map("<F2>", vim.lsp.buf.rename, "Rename object")
		map("<F3>", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
		map("<F4>", vim.lsp.buf.code_action, "Format buffer")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>ga", vim.lsp.buf.code_action, "Code action")
	end,
})

-- lsp_zero.extend_lspconfig({
-- 	sign_text = true,
-- 	lsp_attach = lsp_attach,
-- 	capabilities = require("blink.cmp").get_lsp_capabilities()
-- })

lspconfig.bashls.setup({ capabilities = capabilities })
lspconfig.arduino_language_server.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.csharp_ls.setup({ capabilities = capabilities })
lspconfig.css_variables.setup({ capabilities = capabilities })

lspconfig.cssls.setup({
	capabilities = capabilities,
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

lspconfig.tailwindcss.setup({
	capabilities = capabilities,
	settings = {
		filetypes = { "css", "scss", "less" }
	}
})

lspconfig.clangd.setup({
	capabilities = capabilities,
	cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
	init_options = {
		fallback_flags = { '-std=c++20' },
	},
	settings = {
		["clangd"] = {
			format = {
				insertSpaces = false,
			},
		},
	},
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	settings = {
		imports = {
			granularity = {
				group = "module",
			},
			prefix = "self",
		},
		cargo = {
			buildScripts = {
				enable = true,
			},
		},
		procMacro = {
			enable = true
		},
	}
})

lspconfig.pylsp.setup({
	capabilities = capabilities,
	settings = {
		pylsp = {
			plugins = {
				-- formatter options
				black = { enabled = true },
				autopep8 = { enabled = false },
				yapf = { enabled = false },
				-- linter options
				pylint = { enabled = true, executable = "pylint" },
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
				-- type checker
				pylsp_mypy = { enabled = true },
				-- auto-completion options
				jedi_completion = { fuzzy = true },
				-- import sorting
				pyls_isort = { enabled = true },
			},
		},
	},
	flags = {
		debounce_text_changes = 200,
	},
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
			-- completion = {
			-- 	dispayContext = 5,
			-- }
		})
	end,
	settings = {
		Lua = {}
	}
})

lspconfig.denols.setup({
	capabilities = capabilities,
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = lspconfig.util.root_pattern("module.json", "deno.json", "deno.jsonc", ".git"),
	single_file_support = true,
})
vim.g.markdown_fenced_languages = { "ts=typescript" }

lspconfig.jdtls.setup({
	capabilities = capabilities,
	cmd = { "jdtls", "-configuration", "/home/user/.cache/jdtls/config", "-data", "/home/user/.cache/jdtls/workspace" },
})

lspconfig.ltex_plus.setup({
	capabilities = capabilities,
	filetypes = { "md", "txt", "html", "tex", "bib" }
})

lspconfig.hyprls.setup({
	capabilities = capabilities,
	filetypes = { "hyprlang", "*.hl", "hypr*.conf" },
	single_file_support = true,
})
