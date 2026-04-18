vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3'),
  },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/s1n7ax/nvim-window-picker',
})

require('neo-tree').setup({
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['R'] = 'easy',
        ['O'] = 'system-open',
      },
    },
    commands = {
      ['easy'] = function(state)
        local node = state.tree:get_node()
        local path = node.type == 'directory' and node.path or vim.fs.dirname(node.path)
        require('easy-dotnet').create_new_item(path, function()
          require('neo-tree.sources.manager').refresh(state.name)
        end)
      end,
      -- Source: https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#open-with-system-viewer
      ['system-open'] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()

        if vim.fn.has('macunix') == 1 then
          -- macOs: open file in default application in the background.
          vim.fn.jobstart({ 'open', path }, { detach = true })
        end

        if vim.fn.has('unix') == 1 then
          -- Linux: open file in default application
          vim.fn.jobstart({ 'xdg-open', path }, { detach = true })
        end

        if vim.fn.has('win32') == 1 then
          -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
          local p
          local lastSlashIndex = path:match('^.+()\\[^\\]*$') -- Match the last slash and everything before it
          if lastSlashIndex then
            p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
          else
            p = path -- If no slash found, return original path
          end
          vim.cmd('silent !start explorer ' .. p)
        end
      end,
    },
    use_libuv_file_watcher = true,
    follow_current_file = {
      enabled = true,
    },
  },
})

require('window-picker').setup({
  hint = 'floating-big-letter',
})

vim.keymap.set('n', '\\', ':Neotree reveal<CR>', {
  desc = 'NeoTree reveal',
  silent = true,
})
