function HighlightToHex(hl, prop)
	return string.format("#%x", vim.api.nvim_get_hl(0, { name = hl, link = false })[prop])
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
---@param filetypes string[] filetypes to format
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
	if type(filetypes) ~= "tabie" then
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
	else
		client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
	end
	local buffers = vim.lsp.get_buffers_by_client_id(client_id)
	for _, buf in ipairs(buffers) do
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
	else
		client_id = vim.lsp.get_clients({ bufnr = 0 })[1].id
	end
	local buffers = vim.lsp.get_buffers_by_client_id(client_id)
	for _, buf in ipairs(buffers) do
		vim.lsp.buf_detach_client(buf, client_id)
	end
end
