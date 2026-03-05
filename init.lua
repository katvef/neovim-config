require("katve.functions")
require("katve.remap")

require("katve.katpack").setup({
	configs = "config",
	async_build = true,
	auto_delete = false,
	auto_update = false,
	confirm = { install = false, update = false },
	prefer_config_file = true,
})

require("katve.plugins")
ColorMyPencils()
require("config")
require("katve")
