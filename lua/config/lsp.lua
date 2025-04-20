local lspconfig = require("lspconfig")
local lspconfig_defaults = lspconfig.util.default_config

vim.diagnostic.config({ virtual_text = true })

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	"force",
	lspconfig_defaults.capabilities,
	require("blink.cmp").get_lsp_capabilities()
)

vim.api.nvim_create_autocmd("LspAttach", {
	-- desc = "LSP actions",
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local bufnr = event.buf
		local lsp = vim.lsp.buf
		local function telescope_lsp(action)
			require('telescope.builtin')["lsp_" .. action](require("telescope.theme").get_cursor())
		end
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Stays the same anyway
		map("K", lsp.hover, "Show hover")
		map("gs", vim.lsp.buf.signature_help, "Signature help")
		map("gD", lsp.declaration, "Goto declaration")
		map("<F2>", vim.lsp.buf.rename, "Rename object")
		map("<leader>ga", lsp.code_action, "Code action")
		map("<F4>", lsp.code_action, "Format buffer")
		map("<F3>", function() lsp.format({ async = true }) end, "Format buffer")

		-- Use telescope lsp pickers if telescope exists, otherwise fallback to native functions
		if not pcall(require, 'telescope') then
			map("gd", lsp.definition, "Goto definition")
			map("gi", lsp.implementation, "Goto implementation")
			map("go", lsp.type_definition, "Goto type definition")
			map("gr", lsp.references, "Goto references")
		else
			map("gd", function() telescope_lsp("definitions") end, "Goto definition")
			map("gi", function() telescope_lsp("implementations") end, "Goto implementation")
			map("go", function() telescope_lsp("type_definitions") end, "Goto type definition")
			map("gr", function() telescope_lsp("references") end, "Goto references")
		end

		if client ~= nil and client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end,
})

-- lsp_zero.extend_lspconfig({
-- 	sign_text = true,
-- 	lsp_attach = lsp_attach,
-- 	capabilities = require("blink.cmp").get_lsp_capabilities()
-- })

lspconfig.bashls.setup({})
lspconfig.arduino_language_server.setup({})
lspconfig.jsonls.setup({})
lspconfig.csharp_ls.setup({})
lspconfig.css_variables.setup({})

lspconfig.cssls.setup({
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
	settings = {
		filetypes = { "css", "scss", "less" }
	}
})

lspconfig.clangd.setup({
	cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
	init_options = {
		fallback_flags = { "-std=c++20" },
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
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT"
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
				-- or pull in all of "runtimepath". NOTE: this is a lot slower
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
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = lspconfig.util.root_pattern("module.json", "deno.json", "deno.jsonc", ".git"),
	single_file_support = true,
})
vim.g.markdown_fenced_languages = { "ts=typescript" }

lspconfig.jdtls.setup({
	cmd = { "jdtls", "-configuration", "/home/user/.cache/jdtls/config", "-data", "/home/user/.cache/jdtls/workspace" },
})

lspconfig.ltex_plus.setup({
	filetypes = { "md", "txt", "html", "tex", "bib" }
})

lspconfig.hyprls.setup({
	filetypes = { "hyprlang", "*.hl", "hypr*.conf" },
	single_file_support = true,
})
