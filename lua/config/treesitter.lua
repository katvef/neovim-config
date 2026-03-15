require("nvim-treesitter").setup()

local parsers = require("nvim-treesitter.parsers")

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)

		if parsers[lang] then require("nvim-treesitter").install({ lang }):wait(10000) end

		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
		else
		end
	end,
})
