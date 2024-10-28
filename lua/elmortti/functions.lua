-- Set custom colors foH theme
ColorMyPencils = function()
	vim.cmd("hi cursorline guibg=#1b293b")
	vim.cmd("hi cursorcolumn guibg=#1b293b")
end
ColorMyPencils()
vim.cmd("command! ColorMyPencils lua ColorMyPencils()")

-- Compile current file 
CompileGpp = function()
	local input
	local file
	local args

	input=vim.fn.input("Executable name (ommit to use filename): ")
	if input == "" then
		file=vim.fn.expand("%:t:r")
	else
		file = input
	end

	input=vim.fn.input("Arguments to pass: ")
	if input ~= "" then
		args = " " .. input
	end

	vim.cmd("!g++ -o " .. file .. "%" .. args)
end
vim.cmd("command! CompileGpp lua CompileGpp()")
