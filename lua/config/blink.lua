require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "mono" },

	fuzzy = {
		implementation = "rust",
		frecency = { enabled = true },
		sorts = {
			-- "exact",
			-- function(item_a, item_b)
			-- 	return item_a.score > item_b.score and
			-- 		(item_a.source_id == "snippets" and item_b.source_id ~= "snippets")
			-- end,
			"score",
			"sort_text",
		}
	},

	sources = {
		default = {
			"snippets",
			"lsp",
			"buffer",
			"path",
			"ripgrep"
		},

		providers = {
			snippets = {
				score_offset = 5
			},

			lsp = {
				async = true,
			},

			path = {
				async = true,
				opts = { get_cwd = function(_) return vim.fn.getcwd() end },
			},

			buffer = {
				async = true,
				-- keep case of first char
				transform_items = function(a, items)
					local keyword = a.get_keyword()
					local correct, case
					if keyword:match('^%l') then
						correct = '^%u%l+$'
						case = string.lower
					elseif keyword:match('^%u') then
						correct = '^%l+$'
						case = string.upper
					else
						return items
					end

					-- avoid duplicates from the corrections
					local seen = {}
					local out = {}
					for _, item in ipairs(items) do
						local raw = item.insertText
						if raw:match(correct) then
							local text = case(raw:sub(1, 1)) .. raw:sub(2)
							item.insertText = text
							item.label = text
						end
						if not seen[item.insertText] then
							seen[item.insertText] = true
							table.insert(out, item)
						end
					end
					return out
				end,
				score_offset = -2
			},

			ripgrep = {
				async = true,
				module = "blink-ripgrep",
				name = "Ripgrep",
				backend = { use = "gitgrep-or-ripgrep" },
				toggles = {
					on_off = "<leader>tg"
				},
				score_offset = -1000,
			}

		}
	},

	completion = {
		documentation = { auto_show = true },
		keyword = { range = "full" },

		menu = {
			direction_priority = { "n", "s" },
			auto_show = function()
			---@diagnostic disable-next-line: missing-parameter
				return vim.lsp.buf_is_attached(0) and vim.bo.filetype ~= "markdown"
			end,

			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon" }, { "label", "label_description", "source_name", gap = 1 } },
			},
		},

		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
		},

		list = {
			selection = {
				preselect = true,
				auto_insert = true
			}
		},

		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_without_selection = true,
			show_with_menu = true,
			show_without_menu = true
		},
	},

	signature = {
		enabled = true,
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
		},
		window = { show_documentation = true }
	},
})
