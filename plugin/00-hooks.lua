vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path

    -- [[ L3MON4D3/LuaSnip ]]
    if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
      -- Not supported in Windows & requires make
      if vim.fn.has('win32') ~= 1 and vim.fn.executable('make') == 1 then
        -- Install jsregexp for regex support in snippets
        vim.system({ 'make', 'install_jsregexp' }, { cwd = path })
      end
    end

    -- [[ nvim-telescope/telescope-fzf-native.nvim ]]
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      if vim.fn.executable('make') == 0 and vim.fn.executable('cmake') == 1 then
        vim.system({
          'cmake',
          '-S.',
          '-Bbuild',
          '-DCMAKE_BUILD_TYPE=Release',
          '&&',
          'cmake',
          '--build',
          'build',
          '--config',
          'Release',
          '--target',
          'install',
        }, { cwd = path })
      elseif vim.fn.executable('make') == 1 then
        vim.system({ 'make' }, { cwd = path })
      end
    end
  end,
})
