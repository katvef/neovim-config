-- This module contains a number of default definitions
local rainbow_delimiters = require('rainbow-delimiters')

vim.g.rainbow_delimiters = {
	strategy = {
		[''] = rainbow_delimiters.strategy['global'],
		vim = rainbow_delimiters.strategy['local'],
	},
	query = {
		[''] = 'rainbow-delimiters',
		lua = 'rainbow-delimiters',
	},
	priority = {
		[''] = 110,
		lua = 210,
	},
	highlight = {
		'RainbowDelimiterRed',
		'RainbowDelimiterYellow',
		'RainbowDelimiterBlue',
		'RainbowDelimiterPurple',
		'RainbowDelimiterOrange',
		'RainbowDelimiterGreen',
		-- 'RainbowDelimiterPurple',
		'RainbowDelimiterCyan',
	},
}
