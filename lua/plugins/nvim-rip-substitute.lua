return {
	{
		"chrisgrieser/nvim-rip-substitute",
		cmd = "RipSubstitute",
		keys = {
			{ "<leader>sr", function() require("rip-substitute").sub() end, mode = { "n", "x" }, desc = " rip substitute", },
		},
		config = function()
			require("rip-substitute").setup {
				editingBehavior = { autoCaptureGroups = true },
				notificationOnSuccess = true,

				popupWin = {
					title = " rip-substitute",
					border = "single",
					matchCountHlGroup = "Keyword",
					noMatchHlGroup = "ErrorMsg",
					hideSearchReplaceLabels = false,
					position = "top",
				},

				prefill = {
					normal = "cursorWord",
					visual = "selectionFirstLine",
					startInReplaceLineIfPrefill = false,
					alsoPrefillReplaceLine = false,
				},

				keymaps = {
					abort = "q",
					confirm = "<CR>",
					insertModeConfirm = "<C-CR>",
					prevSubst = "<Up>",
					nextSubst = "<Down>",
					toggleFixedStrings = "<C-f>",
					toggleIgnoreCase = "<C-c>",
					openAtRegex101 = "R",
				},

				incrementalPreview = {
					matchHlGroup = "IncSearch",
					rangeBackdrop = {
						enabled = true,
						blend = 50,
					},
				},

				regexOptions = {
					startWithFixedStringsOn = false,
					startWithIgnoreCase = false,
					pcre2 = true,
					autoBraceSimpleCaptureGroups = true,
				},
			}
		end
	},
}
