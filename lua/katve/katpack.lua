---@class Katpack
---@field plugins table<Katpack.Spec> Plugins installed, indexed by name
---@field config Katpack.Config Katpack configuration options
---@field augroup integer Id of the autocommand group for Katpack
---@field init_done boolean False during neovim startup, true after `VimEnter`
local Katpack = {
	plugins = {},
	config = {},
	augroup = vim.api.nvim_create_augroup("KatpackEvent", { clear = false }),
	init_done = false
}

local plugins_mt = {}
local name_lookup = {}
plugins_mt.__index = name_lookup
setmetatable(Katpack.plugins, plugins_mt)

---@class Katpack.Config
---@field confirm? { install: boolean, update: boolean } Whether to ask confirmation for when installing plugins
---@field update_opts? vim.pack.keyset.update Options for updates
---@field auto_delete? boolean Automatically delete plugins no longer added on startup
---@field auto_update? boolean Automatically update plugins on startup
---@field prefer_config_file? boolean Prefer config file over config function when loading configurations using Katpack.reload
local defaultConfig = {
	confirm = {
		install = false,
		update = true,
	},
	auto_delete = true,
	auto_update = true,
	prefer_config_file = false,
	init_done = false
}

---@class Katpack.Spec : vim.pack.Spec
---@field build? string Command to call to build something required by the plugin.
---@field delete? function Function to run when plugin is deleted
---@field init? function Function to run before updating plugin
---@field branch? string|vim.VersionRange Alternate syntax for version
---@field dependencies? (string|Katpack.Spec)[] Dependencies of the plugin, loaded before
---@field dependency? boolean If the plugin was added as a dependency
---@field module? string|false Name of the module the plugin provides. Used for reloading the plugin and loading opts. Optionally set setup if the plugin uses a non-standard setup path. Set to false to tell the plugin doesn't provide a module.
---@field data nil The contents will be overridden

local function tbl_deep_extend_inplace(dst, src)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			tbl_deep_extend_inplace(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end


---Add plugins to managed plugins
---@param specs (string|Katpack.Spec)[] Specs to add
---@param no_install? boolean Don't install plugins after adding them
function Katpack.add(specs, no_install)
	for _, spec in ipairs(specs) do
		if type(spec) == "string" then
			spec = { src = spec }
		elseif spec.dependencies then
			for _, dep in ipairs(spec.dependencies) do
				if type(dep) == "string" then dep = { src = dep } end
				Katpack.add({ vim.tbl_extend('force', dep, { dependency = true }) }, true)
			end
		end

		if spec.dependency then spec.dependency = true else spec.dependency = false end

		spec.name = (type(spec.name) == 'string' and spec.name or spec.src):match('[^/]+$') or nil

		if spec.module == false then
			spec.module = false
		elseif spec.module ~= nil then
			spec.module = spec.module
		else
			spec.module = spec.name:gsub("%.nvim$", "")
		end

		local existing = Katpack.plugins[spec.name]
		if existing then
			name_lookup[spec.name] = tbl_deep_extend_inplace(existing, spec)
			if existing.dependency then
				Katpack.plugins[spec.name].dependency = (existing.dependency or spec.dependency) and true or false
			end
		else
			plugins_mt.__index[spec.name] = spec
			Katpack.plugins[#Katpack.plugins + 1] = spec
		end
	end

	-- Install all newly added plugins
	if not no_install then Katpack.install() end
end

---@param specs? Katpack.Spec[] Plugins to install or install all new plugins
function Katpack.install(specs)
	specs = specs or Katpack.plugins
	local plugin_specs = {}

	for _, spec in ipairs(specs) do
		plugin_specs[#plugin_specs + 1] = {
			src = spec.src,
			name = spec.name,
			version = spec.branch or spec.version
		}
	end

	vim.pack.add(plugin_specs, { confirm = Katpack.config.confirm.install })
	if not Katpack.init_done then
		for _, plugin in ipairs(specs) do
			plugin.module = vim.fs.dir(vim.pack.get({ plugin.name })[1].path .. "/lua")()
			-- if plugin.priority then Katpack.reload(plugin) end
		end
	end
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
function Katpack.delete(names, force)
	if names == {} or names == nil or names == "" then
		names = vim.iter(vim.pack.get()):filter(function(pack) return not pack.active end)
			 :map(function(pack) return pack.spec.name end)
			 :totable()
			 or {}
	end
	vim.pack.del(names, { force = force })
end

--- Build the plugin
---@param plugin string|Katpack.Spec Plugin name or spec
---@return nil|boolean status, nil|integer exit_code, nil|vim.SystemObj system_object
function Katpack.build(plugin)
	if type(plugin) == "string" then
		plugin = Katpack.plugins[plugin]
		if not plugin then
			vim.notify("Plugin not found", vim.log.levels.ERROR)
			return false, nil, nil
		end
	end
	local build = plugin.build
	if build == nil then return false, nil, nil end
	if build:sub(1, 1) == ":" then
		vim.cmd(build)
	else
		local call = vim.system(vim.split(build, " "),
			{ cwd = vim.pack.get({ plugin.name })[1].path }, function(out)
				if out.code ~= 0 then
					local error = out.stderr and " and message " .. out.stderr or ""
					vim.notify("Building " ..
					plugin.name .. "was unsuccessfull! Program exited with code " .. out.code .. error)
				end
			end)
		return nil, nil, call
	end
end

--- Return the list of plugins and their count
---@return Katpack.Spec[], integer count
---@param filter fun(spec: Katpack.Spec):boolean
function Katpack.get(filter)
	local plugins = filter and vim.iter(Katpack.plugins):filter(filter):totable() or Katpack.plugins
	return vim.deepcopy(plugins, true), vim.tbl_count(plugins)
end

--- Initialize the plugins and generate user commands
function Katpack.init()
	local function plugin_names()
		return vim.tbl_values(vim.tbl_map(function(plugin) return plugin.name end, Katpack.plugins))
	end
	local function complete_name(arg)
		return vim.tbl_filter(function(item) return item:find("^" .. arg) end, plugin_names())
	end

	-- Auto update and delete
	if Katpack.config.auto_delete then
		local inactive = vim.tbl_filter(function(plug_data) return not plug_data.active end, vim.pack.get())
		vim.pack.del(vim.tbl_values(vim.tbl_map(function(plugin) return plugin.spec.name end, inactive)))
	end
	if Katpack.config.auto_update then
		Katpack.update(plugin_names())
	end

	-- Build plugins
	vim.api.nvim_create_autocmd("UIEnter", {
		group = Katpack.augroup,
		callback = function()
			for _, plugin in ipairs(Katpack.plugins) do
				if plugin.build then
					vim.schedule(function() Katpack.build(plugin) end)
				end
			end
		end
	})

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

	vim.api.nvim_create_user_command("KatpackUpdate", function(args)
		Katpack.update(#(args.fargs) > 0 and args.fargs or plugin_names())
	end, { nargs = "*", complete = complete_name, desc = "Update plugins" })

	vim.api.nvim_create_user_command("KatpackDelete", function(args)
		Katpack.delete(args.fargs, false)
	end, { nargs = "*", complete = complete_name, desc = "Delete plugins" })

	vim.api.nvim_create_user_command("Katpack", function(args)
		local iterator = vim.iter(args.fargs)
		local operation = iterator:rev():pop():lower()
		if operation == "update" then
			vim.cmd("KatpackUpdate " .. iterator:join(" "))
		elseif operation == "reload" then
			vim.cmd("KatpackReload " .. iterator:join(" "))
		elseif operation == "delete" then
			vim.cmd("KatpackDelete " .. iterator:join(" "))
		else
			vim.notify("Invalid operation \"" .. operation .. "\"")
		end
	end, {
		nargs = "+",
		complete = function(arg, cmdline)
			local args = vim.split(cmdline, " ")
			if args[2] == "" then
				return vim.tbl_filter(function(item)
					return item:find("^" .. arg)
				end, { "Reload", "Update", "Delete" })
			else
				return complete_name(arg)
			end
		end,
		desc = "Manage plugins"
	})

	-- Set init_done to true
	Katpack.init_done = true
end

---@param config Katpack.Config
function Katpack.setup(config)
	Katpack.config = vim.tbl_deep_extend("force", defaultConfig, config)
	vim.api.nvim_create_autocmd("VimEnter", { group = Katpack.augroup, callback = vim.schedule_wrap(Katpack.init) })
end

return Katpack
