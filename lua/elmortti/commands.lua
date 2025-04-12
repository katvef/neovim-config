-- Change to config directory
vim.api.nvim_create_user_command('Config', 'cd $MYVIMRC/..', { bang = true })
