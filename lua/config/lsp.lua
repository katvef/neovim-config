local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--- Enable and configure server
---@param server_name string
---@param config table|nil
local function lspconfig(server_name, config)
	if config ~= nil then
		vim.lsp.config(server_name, config)
	end
	vim.lsp.enable(server_name)
end

local lspconfig_defaults = require("lspconfig").util.default_config

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
})

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	"force",
	lspconfig_defaults.capabilities,
	require("blink.cmp").get_lsp_capabilities()
)

autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local bufnr = event.buf
		local lsp = vim.lsp.buf

		vim.lsp.inlay_hint.enable()

		local function telescope_lsp(action)
			require("telescope.builtin")["lsp_" .. action](require("telescope.themes").get_cursor())
		end
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("K", lsp.hover, "Show hover")
		map("gs", function()
			lsp.signature_help({ silent = false })
		end, "Signature help")
		map("gD", lsp.declaration, "Goto declaration")
		map("<F2>", lsp.rename, "Rename object")
		map("<leader>ga", lsp.code_action, "Code action")
		map("<F4>", require("tiny-code-action").code_action, "Code action")
		map("<F3>", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, "Format buffer")
		map("gd", function()
			telescope_lsp("definitions")
		end, "Goto definition")
		map("gi", function()
			telescope_lsp("implementations")
		end, "Goto implementation")
		map("go", function()
			telescope_lsp("type_definitions")
		end, "Goto type definition")
		map("gR", function()
			telescope_lsp("references")
		end, "Goto references")
		map("grr", function()
			telescope_lsp("references")
		end, "Goto references")

		map("<F7>", function()
			if vim.lsp.buf_is_attached(0) then
				ReattachClients()
			else
				print("No client attached to buffer")
			end
		end, "Reattach clients to LS")
		map("<F8>", function()
			if vim.lsp.buf_is_attached(0) then
				local client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
				AttachToFiletype({ vim.bo.filetype }, client_id)
			else
				print("No client attached to buffer")
			end
		end, "Attach clients and reformat")

		if client ~= nil and client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end,
})

autocmd("LspAttach", {
	group = augroup("ltex.lsp", { clear = true }),
	callback = function(args)
		if vim.lsp.get_client_by_id(args.data.client_id).name == "ltex_plus" then
			-- Move through lines more easily with wrap on
			vim.keymap.set("n", "j", "gj")
			vim.keymap.set("n", "k", "gk")
			-- Set some options that work better for writing
			vim.opt_local.colorcolumn = "100"
			vim.opt_local.cursorcolumn = false
			vim.opt_local.cursorline = false
			vim.opt_local.linebreak = true
		end
	end,
})

lspconfig("arduino_language_server", {})
lspconfig("jsonls", {})
lspconfig("csharp_ls", {})
lspconfig("basedpyright", {})
lspconfig("jdtls", {})
lspconfig("mesonlsp", {})
lspconfig("neocmake", {})
lspconfig("openscad-lsp", {})
lspconfig("markdown_oxide", {})

lspconfig("bashls", {
	filetypes = { 'bash', 'sh' }
})

lspconfig("ltex_plus", {
	filetypes = {
		"bibtex",
		"gitcommit",
		"markdown",
		"org",
		"tex",
		"restructuredtext",
		"rsweave",
		"latex",
		"quarto",
		"rmd",
		"context",
		"html",
		"xhtml",
		"mail",
		"plaintext",
		"jjdescription",
	},
	settings = {
		ltex = {
			enabled = {
				"bibtex",
				"gitcommit",
				"markdown",
				"org",
				"tex",
				"restructuredtext",
				"rsweave",
				"latex",
				"quarto",
				"rmd",
				"context",
				"html",
				"xhtml",
				"mail",
				"plaintext",
				"jjdescription",
			},
		},
	},
})

lspconfig("cssls", {
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

lspconfig("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--log=verbose",
		"--header-insertion=never",
	},
})

lspconfig("rust_analyzer", {
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
			enable = true,
		},
	},
})

lspconfig("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				 path ~= vim.fn.stdpath("config")
				 and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

lspconfig("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", "module.json", ".git" },
	single_file_support = true,
})

lspconfig("hyprls", {
	filetypes = { "hyprlang", "*.hl", "hypr*.conf" },
	single_file_support = true,
})
