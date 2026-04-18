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
