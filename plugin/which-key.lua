vim.pack.add({
  'https://github.com/folke/which-key.nvim',
})

require('which-key').setup({
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },

  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>g', group = '[G]it', mode = { 'n', 'v' }, icon = { cat = 'filetype', name = 'git' } },
    { '<leader>e', group = '[e]asy-dotnet' },
    {
      '<c-w>',
      group = 'windows',
      expand = function()
        return require('which-key.extras').expand.win()
      end,
    },
  },
  -- Additionally enable which-key for 's' binding (mini.surround)
  triggers = {
    { '<auto>', mode = 'nixsotc' },
  },
})

vim.keymap.set('n', '<c-w>c', '<cmd>close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<c-w>C', '<cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<c-w><c-w>', function()
  require('which-key').show({ keys = '<c-w>', loop = true })
end, {
  desc = 'Window Hydra Mode (which-key)',
})
