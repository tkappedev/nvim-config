vim.api.nvim_create_user_command('PackStatus', function()
  vim.pack.update(nil, { offline = true })
end, {
  desc = 'Show installed packages',
})

vim.api.nvim_create_user_command('PackRestore', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, {
  desc = 'Restore installed packages to lockfile',
})

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {
  desc = 'Update installed packages',
})
