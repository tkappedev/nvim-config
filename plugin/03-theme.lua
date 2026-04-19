vim.pack.add({
  'https://github.com/rebelot/kanagawa.nvim',
})

require('kanagawa').setup({
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = 'none',
        },
      },
    },
  },
  overrides = function(colors)
    local theme = colors.theme
    local palette = colors.palette
    return {
      -- RenderMarkdownH1Bg = { bg = palette.waveBlue1 },
      -- RenderMarkdownH2Bg = { bg = palette.waveBlue2 },
      -- RenderMarkdownH3Bg = { bg = palette.winterGreen },
      -- RenderMarkdownH4Bg = { bg = palette.winterYellow },
      -- RenderMarkdownH5Bg = { bg = palette.winterRed },
      -- RenderMarkdownH6Bg = { bg = palette.winterBlue },
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
      PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
    }
  end,
})

vim.cmd.colorscheme('kanagawa')

-- [[ Update message layout ]]
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'msg',
  callback = function()
    local ui2 = require('vim._core.ui2')
    local win = ui2.wins and ui2.wins.msg
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat,FloatBorder:FloatBorder', {
        scope = 'local',
        win = win,
      })
    end
  end,
})

local ui2 = require('vim._core.ui2')
local msgs = require('vim._core.ui2.messages')

local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
  orig_set_pos(tgt)
  if (tgt == 'msg' or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
    pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
      relative = 'editor',
      anchor = 'NE',
      row = 1,
      col = vim.o.columns - 2,
      border = 'rounded',
    })
  end
end
