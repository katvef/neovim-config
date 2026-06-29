---@param hl string Name of the highlight
---@param prop string Which prop to return
---@return string hex The hex code of the highlight
function HighlightToHex(hl, prop)
	return string.format("#%x", vim.api.nvim_get_hl(0, { name = hl, link = false })[prop] or 0)
end

--- Brighten a hex color
---@param hex string Hex code of the color
---@param amount number Float number to use as the multiplier
function BrightenColor(hex, amount)
	hex = hex:gsub("#", "")

	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	r = math.min(255, math.max(0, math.floor(r * amount)))
	g = math.min(255, math.max(0, math.floor(g * amount)))
	b = math.min(255, math.max(0, math.floor(b * amount)))

	return string.format("#%x%x%x", math.floor(r), math.floor(g), math.floor(b))
end

-- Set custom colors for theme
function ColorMyPencils()
	vim.api.nvim_set_hl(0, "cursorline", { bg = HighlightToHex("colorcolumn", "bg") })
	vim.api.nvim_set_hl(0, "cursorcolumn", { bg = HighlightToHex("colorcolumn", "bg") })
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = HighlightToHex("TabLine", "bg") })
end

ColorMyPencils()
vim.api.nvim_create_user_command("ColorMyPencils", "lua ColorMyPencils()", { bang = true })

--- Attach and format LSP Client to files of matching filetypes
---@param filetypes string|string[] filetypes to format
---@param client_name_or_id string|number|nil Name or id of the client, nil to use first attached to current buffer
function AttachToFiletype(filetypes, client_name_or_id)
	local client_id
	if type(client_name_or_id) == "number" then
		client_id = client_name_or_id
	elseif type(client_name_or_id) == "string" then
		client_id = vim.lsp.get_clients({ name = client_name_or_id })[1].id
	else
		client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
	end
	if client_id == nil then
		return
	end
	if type(filetypes) ~= "table" then
		filetypes = { filetypes }
	end
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_valid(buf) then
			for _, filetype in ipairs(filetypes) do
				if vim.api.nvim_get_option_value("filetype", { buf = buf }) == filetype then
					vim.lsp.buf_attach_client(buf, client_id)
				end
			end
		end
	end
end

--- Reattach LSP Client to all buffers it was attached to
---@param client_name_or_id string|number|nil Name or id of the client, nil to use first attached to current buffer
function ReattachClients(client_name_or_id)
	local client_id
	if type(client_name_or_id) == "number" then
		client_id = client_name_or_id
	elseif type(client_name_or_id) == "string" then
		client_id = vim.lsp.get_clients({ name = client_name_or_id })[1].id
	elseif client_name_or_id == nil then
		client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
	else
		vim.notify("Invalid client name or id", vim.log.levels.ERROR)
	end
	local buffers = vim.lsp.get_client_by_id(client_id).attached_buffers
	for buf, _ in pairs(buffers) do
		vim.lsp.buf_detach_client(buf, client_id)
		vim.lsp.buf_attach_client(buf, client_id)
	end
end

--- Deattach all buffers from LSP Client
---@param client_name_or_id string|number|nil Name or id of the client, nil to use first attached to current buffer
function DeattachClients(client_name_or_id)
	local client_id
	if type(client_name_or_id) == "number" then
		client_id = client_name_or_id
	elseif type(client_name_or_id) == "string" then
		client_id = vim.lsp.get_clients({ name = client_name_or_id })[1].id
	elseif client_name_or_id == nil then
		client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
	else
		vim.notify("Invalid client name or id", vim.log.levels.ERROR)
	end
	local buffers = vim.lsp.get_client_by_id(client_id).attached_buffers
	for buf, _ in pairs(buffers) do
		vim.lsp.buf_detach_client(buf, client_id)
	end
end

local start = {}
local stop = {}
--- Store current time by id
function TimerStart(id, force)
	id = id or 0
	if start[id] ~= nil and force ~= true then return end
	start[id] = vim.uv.hrtime()
	return start[id]
end

--- Print time from id
function TimerStop(id, get)
	id = id or 0
	if get == false then stop[id] = vim.uv.hrtime() end
	return ((stop[id] or vim.uv.hrtime()) - start[id]) / 1e6
end

--- Copy selection with file name and line numbers
function CopyReference(args)
	local path
	local selection_start = args.line1
	local selection_end = args.line2
	local settings = {
		nums = false,
		nopath = false
	}
	for _, arg in ipairs(args.fargs) do
		settings[arg] = true
	end

	-- Make path relative to project root
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
	if git_root ~= "" and vim.v.shell_error == 0 then
		path = vim.fn.expand("%:p")
		if path:sub(1, #git_root) == git_root then
			path = path:sub(#git_root + 2)
		end
	else
		path = vim.fn.expand("%") -- Use path relative to pwd if git root isnẗ found
	end

	if args.range == 0 then
		vim.fn.setreg("+", path .. ": " .. selection_start)
		return
	end

	-- Get range
	local lines = nil
	if selection_start ~= selection_end then
		lines = vim.api.nvim_buf_get_lines(0, selection_start, selection_end + 1, false)
	end


	local val = {}
	if settings.nopath == false then val[#val + 1] = path .. ": " .. selection_start end

	-- Add line numbers
	if settings.nums == true then
		if lines ~= nil then
			for i, line in ipairs(lines) do
				val[#val + 1] = selection_start + i - 1 .. " " .. line
			end
		end
	else
		if lines ~= nil then
			for _, line in ipairs(lines) do
				val[#val + 1] = line
			end
		end
	end

	vim.fn.setreg("+", table.concat(val, "\n"))
end

vim.api.nvim_create_user_command("CopyReference", CopyReference, { range = true, nargs = "*" })
