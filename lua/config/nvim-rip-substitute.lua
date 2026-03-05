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
		confirmAndSubstituteInBuffer = "<CR>",
		insertModeConfirmAndSubstituteInBuffer = "<C-CR>",
		prevSubst = "<Up>",
		nextSubst = "<Down>",
		toggleFixedStrings = "<C-f>",
		toggleIgnoreCase = "<C-c>",
		openAtRegex101 = "R",
	},

	incrementalPreview = {
		matchHlGroup = "IncSearch",
		rangeBackdropBrightness = {
			enabled = true,
			blend = 50,
		},
	},

	regexOptions = {
		startWithFixedStrings = false,
		startWithIgnoreCase = false,
		pcre2 = true,
		autoBraceSimpleCaptureGroups = true,
	},
}

vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("rip-substitute").sub() end, { desc = " rip substitute" })
