local dap = require("dap")
local widgets = require('dap.ui.widgets')

-- Adapters
dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006
}

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "OpenDebugAD7",
}

-- Configurations
dap.configurations.cs = {
	{
		type = "godot",
		name = "launch",
		request = "launch",
		project = "${workspaceFolder}",
		launch_scene = true
	},
	{
		type = "godot",
		name = "attach",
		request = "attach",
		project = "${workspaceFolder}",
		launch_scene = true
	},
	{
		type = "godot",
		name = "set breakpoints",
		request = "setBreakpoints",
		project = "${workspaceFolder}",
		launch_scene = true
	},
	{
		type = "godot",
		name = "get breakpoints",
		request = "breakpointsLocations",
		project = "${workspaceFolder}",
		launch_scene = true
	}
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopAtEntry = true,
		setupCommands = {
			{
				text = '-enable-pretty-printing',
				description = 'enable pretty printing',
				ignoreFailures = false
			},
		},
	},
}

-- Binds
vim.keymap.set('n', '<F5>', require('dap').continue)
vim.keymap.set('n', '<F10>', require('dap').step_over)
vim.keymap.set('n', '<F11>', require('dap').step_into)
vim.keymap.set('n', '<F12>', require('dap').step_out)
vim.keymap.set('n', '<Leader>B', require('dap').toggle_breakpoint)
vim.keymap.set('n', '<Leader>Dt', require('dap').toggle_breakpoint)
vim.keymap.set('n', '<Leader>Dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>Dr', require('dap').repl.open)
-- vim.keymap.set('n', '<Leader>Dl', require('dap').run_last)
vim.keymap.set({ 'n', 'v' }, '<Leader>Dh', require('dap.ui.widgets').hover)
vim.keymap.set({ 'n', 'v' }, '<Leader>Dp', require('dap.ui.widgets').preview)
vim.keymap.set('n', '<Leader>Df', function() widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>Ds', function() widgets.centered_float(widgets.scopes) end)
