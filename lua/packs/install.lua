-- Gotta figure out why I need this line
vim.o.packpath = vim.env.XDG_DATA_HOME .. '/nvim/site'

vim.pack.add({
	'gh:atiladefreitas/dooing',
	'gh:danymat/neogen',
	'gh:williamboman/mason.nvim',
	'gh:brenoprata10/nvim-highlight-colors',
	'gh:stevearc/conform.nvim',
	'gh:mfussenegger/nvim-lint',
	'gh:NeogitOrg/neogit',
	'gh:nvim-mini/mini.icons',
	'gh:HiPhish/rainbow-delimiters.nvim'
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

vim.api.nvim_create_user_command('Update', function(args)
	vim.pack.update(args.nargs > 0 and args.fargs or active_names)
end, { nargs = '*', desc = 'Update plugins' })

local onUpdate = vim.api.nvim_create_augroup('onPluginUpdate', { clear = true })
local change_actions = {}

-- Handle data parameters
for _, plugin in ipairs(active_plugins) do
	if plugin.spec.data then
		local data = plugin.spec.data
		change_actions[plugin.spec.name] = {
			build = data.build,
			config = data.config,
			delete = data.delete,
			pre_update = data.pre_update
		}
	end
end

vim.api.nvim_create_autocmd('PackChanged', {
	group = onUpdate,
	callback = function(ev)
		local actions = change_actions[ev.data.spec.name]
		local kind = ev.data.kind
		if actions == nil then return end
		if kind == 'delete' and actions.delete ~= nil then actions.delete() end
		if kind == 'update' and actions.build ~= nil then actions.build() end
		if kind ~= 'delete' and actions.config ~= nil then actions.config() end
	end
})

vim.api.nvim_create_autocmd('PackChangedPre', {
	group = onUpdate,
	callback = function(ev)
		local actions = change_actions[ev.data.spec.name]
		if ev.data.kind == 'update' and actions.pre_update ~= nil then actions.pre_update() end
	end
})
