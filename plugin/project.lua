vim.pack.add({
  'https://github.com/DrKJeff16/project.nvim',
})

require('project').setup({
  show_hidden = true,
  lsp = {
    enabled = true,
    ignore = {
      'copilot',
      'easy_dotnet', -- causes issues due to root directory containing trailing '/' (at least on windows)
      'docker_language_server',
      'helm_ls',
    },
  },
})

pcall(require('telescope').load_extension, 'projects')

vim.keymap.set('n', '<leader>sp', function()
  require('telescope').extensions.projects.projects({})
end, { desc = '[S]earch recent [P]rojects' })
