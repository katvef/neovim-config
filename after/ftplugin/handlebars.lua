vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.treesitter.language.register("handlebars", { "handlebars" })
vim.schedule(function() vim.bo.syntax = "handlebars" end)
