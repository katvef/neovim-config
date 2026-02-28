---@class Katpack
---@field plugins table<Katpack.Spec> Plugins installed, indexed by name
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

---@class Katpack.Config
---@field configs? string|string[] Directory where the configuration files are stored or list of config files
---@field confirm? { install: boolean, update: boolean } Wheter to ask confirmation for when installing plugins
---@field update_opts? vim.pack.keyset.update Options for updates
---@field auto_delete? boolean Automatically delete plugins no longer added on startup
---@field auto_update? boolean Automatically update plugins on startup
---@field prefer_config_file? boolean Prefer config file over config function when loading configurations using Katpack.reload
---@field async_build? boolean Run build commands asynchronously
local defaultConfig = {
	confirm = {
		install = false,
		update = false,
	},
	auto_delete = true,
	auto_update = true,
	async_build = true,
	prefer_config_file = false
}

---@class Katpack.Spec : vim.pack.Spec
---@field build? string Command to call to build something required by the plugin
---@field config? string|function Function to configure the plugin or name of the config file
---@field delete? function Function to run when plugin is deleted
---@field init? function Function to run before updating plugin
---@field branch? string|vim.VersionRange Alternate syntax for version
---@field dependencies? Katpack.Spec[] Dependencies of the plugin, loaded before
---@field dependency? boolean If the plugin was added as a dependency
---@field data nil The contents will be overriden

---Add plugins to managed plugins
---@param specs (string|Katpack.Spec)[]
function Katpack.add(specs)
	for _, spec in ipairs(specs) do
		if type(spec) == "string" then
			spec = { src = spec, name = spec:match('[^/]+$') }
		elseif spec.dependencies then
			for _, dep in ipairs(spec.dependencies) do
				Katpack.add({ vim.tbl_extend('force', dep, { dependency = true }) })
			end
		end
		spec.dependency = spec.dependency and true or false
		spec.name = (type(spec.name) == 'string' and spec.name or ''):match('[^/]+$') or ''

		local existing = Katpack.plugins[spec.name]
		if existing then
			Katpack.plugins[spec.name] = vim.tbl_deep_extend('force', existing, spec)
			if existing.dependency then
				Katpack.plugins[spec.name].dependency = (existing.dependency or spec.dependency) and true or false
			end
		else
			Katpack.plugins[spec.name] = spec
		end

		Katpack.install({ spec })
	end
end

---@param specs? Katpack.Spec[] Specs to install or install all new specs
function Katpack.install(specs)
	specs = specs or Katpack.plugins
	local plugin_specs = {}

	for _, spec in ipairs(specs) do
		local katpack_data = {}
		if spec.config ~= nil then katpack_data.config = spec.config end
		if spec.init ~= nil then katpack_data.init = spec.init end
		if spec.branch ~= nil then katpack_data.branch = spec.branch end
		if spec.dependencies ~= nil then katpack_data.dependencies = spec.dependencies end
		if spec.dependency ~= nil then katpack_data.dependency = spec.dependency end

		plugin_specs[#plugin_specs + 1] = {
			src = spec.src,
			name = spec.name,
			version = spec.branch or spec.version,
			data = katpack_data
		}
	end

	vim.pack.add(plugin_specs, { confirm = Katpack.config.confirm.install })
	for _, plugin in ipairs(plugin_specs) do if plugin.build then Katpack.build(plugin) end end
end

---@param names string[] List of plugins to update
---@param opts? vim.pack.keyset.update
function Katpack.update(names, opts)
	opts = opts or {}
	opts.force = opts.force or not Katpack.config.confirm.update
	vim.pack.update(names, opts)
end

---@param names string[] List of plugins to delete
---@param force? boolean Delete plugin even if active
function Katpack.delete(names, force) vim.pack.del(names, { force = force }) end

--- Build the plugin
---@param plugin string|Katpack.Spec Plugin name or spec
function Katpack.build(plugin)
	if type(plugin) == "string" then
		plugin = Katpack.plugins[plugin]
		if not plugin then
			vim.notify("Plugin not found", vim.log.levels.ERROR)
			return false, nil
		end
	end
	local build = plugin.build
	if build == nil then return false end
	if build[1] == ":" then
		vim.cmd(vim.split(build, " "))
	else
		local call = vim.system(vim.split(build, " "), function(out)
			if out.code ~= 0 then
				local error = out.stderr and " and message " .. out.stderr or ""
				vim.notify("Building " .. plugin.name .. "was unsuccessfull! Program exited with code " .. out.code .. error)
			end
		end)
		if not Katpack.config.async_build then
			call:wait()
		end
	end
end

--- Reload provided plugin's config
---@param plugin string|Katpack.Spec
function Katpack.reload(plugin)
	if type(plugin) == "string" then plugin = Katpack.plugins[plugin] end
	local config = plugin.config
	if config == nil or (Katpack.config.prefer_config_file and type(config) == "function") then
		config = Katpack.config.configs[plugin.name]
		if not config then
			vim.notify("No config found for " .. plugin.name, vim.log.levels.ERROR)
			return
		end
	end
	if type(config) == "function" then
		config()
	elseif type(config) == "string" then
		local stat = vim.uv.fs_stat(config)
		if not stat or stat.type ~= "file" then
			vim.notify("No file found at " .. config, vim.log.levels.ERROR)
			return
		end
	end
end

--- Return the list of plugins and their count
---@return Katpack.Spec[], integer count
---@param filter fun(spec: Katpack.Spec):boolean
function Katpack.get_specs(filter)
	local plugins = filter and vim.iter(Katpack.plugins):filter(filter):totable() or Katpack.plugins
	return plugins, vim.tbl_count(plugins)
end

--- Initialize the plugins and generate user commands
function Katpack.init()
	local plugin_names = vim.tbl_values(vim.tbl_map(function(plugin) return plugin.name end, Katpack.plugins))

	-- Auto update and delete
	if Katpack.config.auto_delete then
		local inactive = vim.tbl_filter(function(plug_data) return not plug_data.active end, vim.pack.get(plugin_names))
		vim.pack.del(vim.tbl_values(vim.tbl_map(function(plugin) return plugin.spec.name end, inactive)))
	end
	if Katpack.config.auto_update then
		Katpack.update(plugin_names)
	end

	-- Define auto commands
	vim.api.nvim_create_autocmd("PackChanged", {
		group = Katpack.augroup,
		callback = function(ev)
			local plugin = Katpack.plugins[ev.data.spec.name]
			local kind = ev.data.kind
			if plugin == nil then return end
			if kind == "delete" and plugin.delete then plugin.delete() end
			if kind == "update" and plugin.build then Katpack.build(plugin) end
			if kind ~= "delete" and plugin.config then plugin.config() end
		end
	})

	vim.api.nvim_create_autocmd("PackChangedPre", {
		group = Katpack.augroup,
		callback = function(ev)
			local plugin = Katpack.plugins[ev.data.spec.name] ---@type Katpack.Spec
			if ev.data.kind ~= "delete" and plugin.init then plugin.init() end
		end
	})

	-- Define user commands
	vim.api.nvim_create_user_command("KatpackReload", function(args)
		for _, arg in ipairs(args.fargs) do Katpack.reload(arg) end
	end, {
		nargs = "+",
		complete = function(arg)
			local matches = {}
			for _, plugin in pairs(plugin_names) do
				if plugin:match("^", arg) then
					matches[#matches + 1] = plugin
				end
			end
			return matches
		end,
		desc = "Reload plugins"
	})

	vim.api.nvim_create_user_command("KatpackUpdate", function(args)
		Katpack.update(args.nargs > 0 and args.fargs or plugin_names)
	end, {
		nargs = "*",
		complete = function(arg)
			local matches = {}
			for _, plugin in pairs(plugin_names) do
				if plugin:match("^", arg) then
					matches[#matches + 1] = plugin
				end
			end
			return matches
		end,
		desc = "Update plugins"
	})

	vim.api.nvim_create_user_command("KatpackDelete", function(args)
		Katpack.delete(args.nargs > 0 and args.fargs or plugin_names, false)
	end, {
		nargs = "*",
		complete = function(arg)
			local matches = {}
			for _, plugin in pairs(plugin_names) do
				if plugin:match("^", arg) then
					matches[#matches + 1] = plugin
				end
			end
			return matches
		end,
		desc = "Delete plugins"
	})

	vim.api.nvim_create_user_command("Katpack", function(args)
		local iterator = vim.iter(args.fargs)
		local operation = iterator:pop():lower()
		if operation == "update" then
			vim.cmd("KatpackUpdate " .. iterator:join(" "))
		elseif operation == "reload" then
			vim.cmd("KatpackUpdate " .. iterator:join(" "))
		elseif operation == "delete" then
			vim.cmd("KatpackUpdate " .. iterator:join(" "))
		else
			vim.notify("Invalid operation \"" .. operation .. "\"")
		end
	end, {
		nargs = "+",
		complete = function(arg, cmdline)
			local args = vim.split(cmdline, " ")
			if args[2] == nil then
				local matches = {}
				for _, plugin in ipairs({ "Reload", "Update", "Delete" }) do
					if plugin:match("^", arg) then
						matches[#matches + 1] = plugin
					end
				end
				return matches
			else
				local matches = {}
				for _, plugin in pairs(plugin_names) do
					if plugin:match("^", arg) then
						matches[#matches + 1] = plugin
					end
				end
				return matches
			end
		end,
		desc = "Manage plugins"
	})

	-- Set init_done to true
	Katpack.init_done = true
end

---@param config Katpack.Config
function Katpack.setup(config)
	local configs = {}
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
					configs[vim.fn.fnamemodify(name, ":t:r")] = vim.fn.fnamemodify(config_path .. "/" .. name, ":p")
				end
			end
		end
	elseif type(config.configs) == "table" then
		---@diagnostic disable-next-line: param-type-mismatch
		for _, file in ipairs(config.configs) do
			file = vim.fn.fnamemodify(vim.fn.stdpath("config") .. "/lua/" .. file, ":p")
			local stat = vim.uv.fs_stat(file)
			if stat and stat.type == "file" then
				configs[vim.fn.fnamemodify(file, ":t:r")] = file
			else
				vim.notify("Config file \"" .. file .. "\"is not found or isn't a file!", vim.log.levels.WARN)
			end
		end
	end

	Katpack.config = vim.tbl_deep_extend("force", defaultConfig, config, { configs })

	vim.api.nvim_create_autocmd("VimEnter", { group = Katpack.augroup, callback = vim.schedule_wrap(Katpack.init) })
end

return Katpack
