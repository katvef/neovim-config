require("codecompanion").setup({
	strategies = {
		chat = {
			ollama = {
				adapter = "ollama"
			},
			inline = {
				adapter = "ollama"
			}
		}
	},
	adapters = {
		qwen25 = function()
			return require("codecompanion.adapters").extend("ollama", {
				name = "qwen2.5-coder",
				schema = {
					model = {
						default = "qwen2.5-coder"
					},
					num_ctx = {
						default = 16384
					},
					num_predict = {
						default = -1
					}
				}
			})
		end
	}
})
