vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
})

local oil = require('oil')

oil.setup({
  keymaps = {
    ['g?'] = { 'actions.show_help', mode = 'n' },
    ['<CR>'] = 'actions.select',
    ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-S>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-h>'] = false,
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = { 'actions.close', mode = 'n' },
    ['\\'] = { 'actions.close', mode = 'n' },
    ['gf'] = 'actions.refresh',
    ['<C-l>'] = false,
    ['-'] = { 'actions.parent', mode = 'n' },
    ['<BS>'] = { 'actions.parent', mode = 'n' },
    ['_'] = { 'actions.open_cwd', mode = 'n' },
    ['`'] = { 'actions.cd', mode = 'n' },
    ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
    ['gs'] = { 'actions.change_sort', mode = 'n' },
    ['gx'] = 'actions.open_external',
    ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
    ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
  },
})

vim.keymap.set('n', '\\', oil.open, {
  desc = 'Oil reveal',
  silent = true,
})
