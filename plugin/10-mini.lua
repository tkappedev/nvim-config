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

local MiniFiles = require('mini.files')
MiniFiles.setup()

vim.keymap.set('n', '\\', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, {
  desc = 'MiniFiles reveal',
  silent = true,
})

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = 'Split ' .. direction
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

local yank_path = function()
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify('Cursor is not on valid entry')
  end
  vim.fn.setreg(vim.v.register, path)
end

local ui_open = function()
  vim.ui.open(MiniFiles.get_fs_entry().path)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id

    map_split(buf_id, 'S', 'belowright horizontal')
    map_split(buf_id, '<C-s>', 'belowright vertical')
    map_split(buf_id, '<C-t>', 'tab')

    vim.keymap.set('n', 'gy', yank_path, { buffer = buf_id, desc = 'Yank path' })
    vim.keymap.set('n', 'gX', ui_open, { buffer = buf_id, desc = 'OS open' })
  end,
})
