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

vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopeFindPre',
  callback = function()
    if _G.MiniFiles then
      _G.MiniFiles.close()
    end
  end,
})

-- https://github.com/nvim-mini/mini.nvim/discussions/2173#discussioncomment-15272407
-- Window width based on the offset from the center, i.e. center window
-- is 60, then next over is 20, then the rest are 10.
-- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
local widths = { 60, 20, 10 }

local ensure_center_layout = function(ev)
  local state = MiniFiles.get_explorer_state()
  if state == nil then
    return
  end

  -- Compute "depth offset" - how many windows are between this and focused
  local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match('^minifiles://%d+/(.*)$')
  local depth_this
  for i, path in ipairs(state.branch) do
    if path == path_this then
      depth_this = i
    end
  end
  if depth_this == nil then
    return
  end
  local depth_offset = depth_this - state.depth_focus

  -- Adjust config of this event's window
  local i = math.abs(depth_offset) + 1
  local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
  win_config.width = i <= #widths and widths[i] or widths[#widths]

  win_config.zindex = 99
  win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
  local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
  for j = 1, math.abs(depth_offset) do
    -- widths[j+1] for the negative case because we don't want to add the center window's width
    local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
    -- Add an extra +2 each step to account for the border width
    local new_col = win_config.col + sign * (prev_win_width + 2)
    if (new_col < 0) or (new_col + win_config.width > vim.o.columns) then
      win_config.zindex = win_config.zindex - 1
      break
    end
    win_config.col = new_col
  end

  win_config.height = depth_offset == 0 and 24 or 20
  win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
  -- win_config.border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
  win_config.footer = { { tostring(depth_offset), 'Normal' } }
  vim.api.nvim_win_set_config(ev.data.win_id, win_config)
end

vim.api.nvim_create_autocmd('User', { pattern = 'MiniFilesWindowUpdate', callback = ensure_center_layout })
