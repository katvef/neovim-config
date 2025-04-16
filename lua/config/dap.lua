local dap = require("dap")

dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006
}

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
