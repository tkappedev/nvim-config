-- Remove stuck ShaDa.tmp.* files, see: https://github.com/neovim/neovim/issues/8587#issuecomment-3557794273
vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Delete empty temp ShaDa files',
  group = vim.api.nvim_create_augroup('remove_shada_temp', { clear = true }),
  pattern = '*',
  callback = function()
    local status = 0
    for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath 'data' .. '/shada', '*tmp*', false, true)) do
      if vim.tbl_isempty(vim.fn.readfile(f)) then
        status = status + vim.fn.delete(f)
      end
    end
    if status ~= 0 then
      vim.notify('Could not delete empty temporary ShaDa files.', vim.log.levels.ERROR)
      vim.fn.getchar()
    end
  end,
})
