local gd_project_path = vim.fs.root(0, "project.godot")
local gd_server_running = gd_project_path ~= nil and vim.uv.fs_stat(gd_project_path .. "/server.pipe") or false

-- Start server in godot project if it isn't active
if gd_project_path ~= nil and not gd_server_running then
	vim.fn.serverstart(gd_project_path .. "/server.pipe")
elseif gd_server_running then
	vim.notify("Godot server is already running at " .. gd_project_path, vim.log.levels.ERROR)
end

-- This could be useful in other contexts too, but I use it exclusively with godot external editor
vim.api.nvim_create_user_command("GDOpenFile", function(args)
	local file = args.args
	local full_filename = vim.fn.fnamemodify(file, ":p")
	local win = -1
	if vim.api.nvim_get_current_buf() == 1 and vim.api.nvim_buf_get_name(0) == "" then
		vim.cmd("e " .. vim.fn.fnameescape(full_filename))
		return
	end
	if vim.uv.fs_stat(full_filename) then
		local buf_ids = vim.api.nvim_list_bufs()
		local buf_names = {}
		for _, id in ipairs(buf_ids) do
			buf_names[id] = vim.api.nvim_buf_get_name(id)
		end
		for id, name in pairs(buf_names) do
			if vim.fn.fnamemodify(name, ":p") == full_filename then
				win = vim.fn.win_findbuf(id)[1]
				break
			end
		end
		if win ~= -1 then
			vim.api.nvim_set_current_tabpage(vim.api.nvim_win_get_tabpage(win))
		else
			vim.cmd("tabedit " .. vim.fn.fnameescape(full_filename))
		end
	end
end, { nargs = 1, desc = "Switch to tab and buffer with the file or open it in a new tab" })
