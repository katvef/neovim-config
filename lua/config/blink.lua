require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "mono" },

	fuzzy = {
		implementation = "rust",
		use_frecency = true,
		sorts = {
			"exact",
			-- function(item_a, item_b)
			-- 	return item_a.score > item_b.score and
			-- 		(item_a.source_id == "snippets" and item_b.source_id ~= "snippets")
			-- end,
			"score",
			"sort_text",
		}
	},

	sources = {
		default = { "lsp", "snippets", "buffer", "path" },

		providers = {
			path = { opts = { get_cwd = function(_) return vim.fn.getcwd() end } },

			buffer = {
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
				end
			}
		}
	},

	completion = {
		documentation = { auto_show = true },
		keyword = { range = "full" },

		menu = {
			direction_priority = { "n", "s" },
			auto_show = function()
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
		window = { show_documentation = false }
	},
})
