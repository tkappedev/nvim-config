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
  telescope = {
    disable_file_picker = true,
    mappings = {
      n = {
        r = 'rename_project',
        b = 'browse_project_files',
        d = 'delete_project',
        f = 'find_project_files',
        ['.'] = 'recent_project_files',
        s = 'search_in_project_files',
        w = 'change_working_directory',
      },
      i = {
        ['<C-b>'] = 'browse_project_files',
        ['<C-d>'] = 'delete_project',
        ['<C-f>'] = 'find_project_files',
        ['<C-n>'] = '',
        ['<C-r>'] = 'rename_project',
        ['<C-.>'] = 'recent_project_files',
        ['<C-s>'] = 'search_in_project_files',
        ['<C-w>'] = 'change_working_directory',
      },
    },
    prefer_file_browser = false,
    sort = 'newest', ---@type 'oldest'|'newest'
    tilde = true,
  },
})

pcall(require('telescope').load_extension, 'projects')

vim.keymap.set('n', '<leader>sp', function()
  require('telescope').extensions.projects.projects({})
end, { desc = '[S]earch recent [P]rojects' })
