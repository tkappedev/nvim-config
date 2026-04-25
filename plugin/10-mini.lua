vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
})

require('mini.ai').setup({ n_lines = 500 })

require('mini.surround').setup({
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    replace = 'gsr',
  },
})

local files = require('mini.files')
files.setup()

vim.keymap.set('n', '\\', files.open, {
  desc = 'Files reveal',
  silent = true,
})
