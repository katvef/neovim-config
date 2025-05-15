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
			require('telescope.builtin')["lsp_" .. action](require("telescope.themes").get_cursor())
		end
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Stays the same anyway
		map("K", lsp.hover, "Show hover")
		map("gs", vim.lsp.buf.signature_help, "Signature help")
		map("gD", lsp.declaration, "Goto declaration")
		map("<F2>", lsp.rename, "Rename object")
		map("<leader>ga", lsp.code_action, "Code action")
		map("<F4>", lsp.code_action, "Code action")
		map("<F3>", function() lsp.format({ async = true }) end, "Format buffer")

		-- Use telescope lsp pickers if telescope exists, otherwise fallback to native functions
		if not pcall(require, 'telescope') then
			map("gd", lsp.definition, "Goto definition")
			map("gi", lsp.implementation, "Goto implementation")
			map("go", lsp.type_definition, "Goto type definition")
			map("gR", lsp.references, "Goto references")
		else
			map("gd", function() telescope_lsp("definitions") end, "Goto definition")
			map("gi", function() telescope_lsp("implementations") end, "Goto implementation")
			map("go", function() telescope_lsp("type_definitions") end, "Goto type definition")
			map("gR", function() telescope_lsp("references") end, "Goto references")
			map("grr", function() telescope_lsp("references") end, "Goto references")
		end

		if client ~= nil and client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end,
})

lspconfig.bashls.setup({})
lspconfig.arduino_language_server.setup({})
lspconfig.jsonls.setup({})
lspconfig.csharp_ls.setup({})
lspconfig.basedpyright.setup({})
lspconfig.jdtls.setup({})
-- lspconfig.ltex_plus.setup({})
lspconfig.ltex.setup({})

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
		filetypes = { "css", "scss", "less", "rasi" },
		single_file_support = true,
	},
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

lspconfig.lua_ls.setup({
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath('config')
				and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT',
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

lspconfig.denols.setup({
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "deno.json", "deno.jsonc" },
	single_file_support = true,

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(0, 'LspDenolsCache', function()
			client:exec_cmd({
				command = 'deno.cache',
				arguments = { {}, vim.uri_from_bufnr(bufnr) },
			}, { bufnr = bufnr }, function(err, _result, ctx)
				if err then
					local uri = ctx.params.arguments[2]
					vim.api.nvim_err_writeln('cache command failed for ' .. vim.uri_to_fname(uri))
				end
			end)
		end, {
			desc = 'Cache a module and all of its dependencies.',
		})
		vim.g.markdown_fenced_languages = { "ts=typescript" }
	end,
})

lspconfig.ts_ls.setup({
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", "module.json", ".git" },
	single_file_support = true,
})

lspconfig.hyprls.setup({
	filetypes = { "hyprlang", "*.hl", "hypr*.conf" },
	single_file_support = true,
})
