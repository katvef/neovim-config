vim.api.nvim_create_user_command('Config', 'cd $MYVIMRC/..', { bang = true, desc = "Change to config directory" })
