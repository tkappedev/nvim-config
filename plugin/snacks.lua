vim.pack.add({
  'https://github.com/folke/snacks.nvim',
})

require('snacks').setup({
  lazygit = {},
})

vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

vim.keymap.set('n', '<leader>gl', function()
  Snacks.lazygit.log_file()
end, { desc = 'Lazygit current file [l]og' })
