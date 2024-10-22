local input
local file

Compile = function()
	input=vim.fn.input("Executable name: ")
	if input == "" then
		file=vim.fn.substitute(vim.fn.expand("%:r"), "\\.cpp", "", "")
	else
		file = input
	end
	vim.cmd("!g++ -o " .. file .. "%")
end
