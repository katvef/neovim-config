---@class Katpack.Spec : vim.pack.Spec
---@field build? string Command to call to build something required by the plugin
---@field config? string|function Function to configure the plugin or name of the config file
---@field init? function Function to run before updating plugin
---@field branch? string|vim.VersionRange Alternate syntax for version
---@field dependencies? Katpack.Spec[] Dependencies of the plugin, loaded before
---@field _dependency? boolean If the plugin was added as a dependency
---@field _installed? boolean If the plugin has been installed
---@field data nil The contents will be overriden

---@class Katpack.Config
---@field configs? string|string[] Directory where the configuration files are stored or list of config files
---@field auto_delete? boolean Automatically delete plugins no longer added on startup
---@field auto_update? boolean Automatically update plugins on startup

---@class Katpack
---@field plugins Katpack.Spec[] Plugins installed
---@field config Katpack.Config Configuration that is used
---@field augroup integer Id of the autocommand group for Katpack
---@field init_done boolean False during neovim startup, true after `VimEnter`
local Katpack = {
	plugins = {},
	config = {},
	augroup = vim.api.nvim_create_augroup("KatpackEvent",
		{ clear = true --[[set to false after development is done]] }),
	init_done = false
}

---Add plugin to managed plugins
---@param specs (string|Katpack.Spec)[]
function Katpack.add(specs)
	for _, spec in ipairs(specs) do
		if type(spec) == "string" then
			spec = { src = spec }
		elseif spec.dependencies then
			for _, dep in ipairs(spec.dependencies) do
				Katpack.add({ vim.tbl_extend('force', dep, { _dependency = true }) })
			end
		end
		Katpack.plugins[#Katpack.plugins + 1] = spec
	end
end

---@param specs? Katpack.Spec[] Specs to install or install all new specs
function Katpack.install(specs)

end

---@param config Katpack.Config
function Katpack.setup(config)
	if type(config.configs) == "string" then
		local config_path = vim.fn.stdpath("config") .. "/lua/" .. config.configs
		local config_stat = vim.uv.fs_stat(config_path)

		if not config_stat then
			vim.notify("Config directory not found! Make sure the directory provided is relative to the lua directory",
				vim.log.levels.ERROR)
		elseif config_stat.type ~= "directory" then
			vim.notify("Configs must be a directory or a list of files!", vim.log.levels.ERROR)
		else
			for name, type in vim.fs.dir(config_path) do
				if type == "file" then
					Katpack.config[vim.fn.fnamemodify(name, ":t:r")] = vim.fn.fnamemodify(config_path .. "/" .. name, ":p")
				end
			end
		end
	elseif type(config.configs) == "table" then
		---@diagnostic disable-next-line: param-type-mismatch
		for _, file in ipairs(config.configs) do
			file = vim.fn.fnamemodify(vim.fn.stdpath("config") .. "/lua/" .. file, ":p")
			local stat = vim.uv.fs_stat(file)
			if stat and stat.type == "file" then
				Katpack.config[vim.fn.fnamemodify(file, ":t:r")] = file
			else
				vim.notify("Config file \"" .. file .. "\"is not found or isn't a file!", vim.log.levels.WARN)
			end
		end
	end

	vim.api.nvim_create_autocmd("VimEnter", { group = Katpack.augroup, callback = Katpack.init() })
end

--- Initialize the plugins and generate user commands
function Katpack.init()
	Katpack.init_done = true
end

vim.pack.add({
	"gh:atiladefreitas/dooing",
	"gh:danymat/neogen",
	"gh:williamboman/mason.nvim",
	"gh:brenoprata10/nvim-highlight-colors",
	"gh:stevearc/conform.nvim",
	"gh:mfussenegger/nvim-lint",
	"gh:NeogitOrg/neogit",
	"gh:nvim-mini/mini.icons",
	"gh:HiPhish/rainbow-delimiters.nvim"
})

local installed_plugins = vim.pack.get()
local inactive_names = {}
local active_plugins = {}
local active_names = {}

for _, plugin in ipairs(installed_plugins) do
	if plugin.active == false then
		inactive_names[#inactive_names + 1] = plugin.spec.name
	else
		active_plugins[#active_plugins + 1] = plugin
		active_names[#active_names + 1] = plugin.spec.name
	end
end

-- Delete removed plugins
vim.pack.del(inactive_names)

vim.api.nvim_create_user_command("Update", function(args)
	vim.pack.update(args.nargs > 0 and args.fargs or active_names)
end, { nargs = "*", desc = "Update plugins" })

local onUpdate = vim.api.nvim_create_augroup("onPluginUpdate", { clear = true })
local change_actions = {}

-- Handle data parameters
for _, plugin in ipairs(active_plugins) do
	if plugin.spec.data then
		local data = plugin.spec.data
		change_actions[plugin.spec.name] = {
			build = data.build,
			config = data.config,
			delete = data.delete,
			init = data.init
		}
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	group = onUpdate,
	callback = function(ev)
		local actions = change_actions[ev.data.spec.name]
		local kind = ev.data.kind
		if actions == nil then return end
		if kind == "delete" and actions.delete ~= nil then actions.delete() end
		if kind == "update" and actions.build ~= nil then actions.build() end
		if kind ~= "delete" and actions.config ~= nil then actions.config() end
	end
})

vim.api.nvim_create_autocmd("PackChangedPre", {
	group = onUpdate,
	callback = function(ev)
		local actions = change_actions[ev.data.spec.name]
		if ev.data.kind ~= "delete" and actions.init ~= nil then actions.init() end
	end
})

return Katpack
