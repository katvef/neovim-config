require("pendulum").setup({
	log_file = vim.env.HOME .. "/.pendulum-log.csv",
	timeout_len = 300,
	timer_len = 120,
	gen_reports = true,
	top_n = 10,
	hours_n = 10,
	time_format = "24h",
	time_zone = "Finland/Helsinki",
	report_excludes = {
		branch = { "unknown_branch" },
		directory = {},
		file = {},
		filetype = { "minifiles", "unknown_filetype" },
		project = { "unknown_project" },
	},
	report_section_excludes = { "directory", "file", "filetype" },
})
