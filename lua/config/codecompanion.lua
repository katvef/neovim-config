require("codecompanion").setup({
	adapters = {
		opts = {
			show_defaults = false
		},
		qwen = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
				schema = {
					model = {
						default = "qwen2.5-coder:latest",
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
			})
		end,
		deepseek = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "deepseek", -- Give this adapter a different name to differentiate it from the default ollama adapter
				schema = {
					model = {
						default = "deepseek-coder-v2:latest",
					},
					num_ctx = {
						default = 16384,
					},
					num_predict = {
						default = -1,
					},
				},
			})
		end,
	},
	strategies = {
		chat = {
			chat = {
				adapter = "qwen"
			},
			inline = {
				adapter = "qwen"
			}
		}
	},
})

