return {
	"nvim-lualine/lualine.nvim",
	priority = 1000,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require('lualine').setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = { left = '│', right = '│' },
				section_separators = { left = '', right = '' },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				}
			},

			sections = {
				lualine_a = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
					},
					{
						'mode',
						cond = function() return not require("noice").api.statusline.mode.has() end,
					}
				},
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { { 'filename', path = 0, newfile_status = true },
					function() return require('lsp-progress').progress() end,
				},

				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'filesize', function() return vim.fn.line('$') end },
				lualine_z = { 'location', 'progress' },
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {}
			},

			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {}
		})

		-- listen lsp-progress event and refresh lualine
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end
}
