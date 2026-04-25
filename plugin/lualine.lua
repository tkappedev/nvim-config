vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
})

local theme = require('lualine.themes.auto')
theme.terminal = {
  a = { fg = '#121715', bg = '#4bc997' },
}

local easy_dotnet = {
  sections = {
    lualine_a = {
      'mode',
      function()
        return require('easy-dotnet.ui-modules.jobs').lualine()
      end,
    },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  filetypes = { 'cs', 'csproj', 'sln', 'slnx' },
}

require('lualine').setup({
  options = { theme = theme },
  extensions = { 'toggleterm', 'nvim-dap-ui', easy_dotnet },
  sections = {
    lualine_a = { 'mode' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
  },
})
