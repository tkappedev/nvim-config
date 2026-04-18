vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
})

-- To install additional lsp
require('mason').setup()

-- Shows live lsp state in bottom right
require('fidget').setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- [[ Keymaps ]]
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, {
      buffer = event.buf,
      desc = 'LSP: [R]e[n]ame',
    })

    vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
      buffer = event.buf,
      desc = 'LSP: [G]oto Code [A]ction',
    })

    vim.keymap.set('n', 'grr', require('telescope.builtin').lsp_references, {
      buffer = event.buf,
      desc = 'LSP: [G]oto [R]eferences',
    })

    vim.keymap.set('n', 'gri', require('telescope.builtin').lsp_implementations, {
      buffer = event.buf,
      desc = 'LSP: [G]oto [I]mplementation',
    })

    vim.keymap.set('n', 'grd', require('telescope.builtin').lsp_definitions, {
      buffer = event.buf,
      desc = 'LSP: [G]oto [D]efinition',
    })
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, {
      buffer = event.buf,
      desc = 'LSP: [G]oto [D]eclaration',
    })

    vim.keymap.set('n', 'gO', require('telescope.builtin').lsp_document_symbols, {
      buffer = event.buf,
      desc = 'LSP: Open Document Symbols',
    })

    vim.keymap.set('n', 'gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, {
      buffer = event.buf,
      desc = 'LSP: Open Workspace Symbols',
    })

    vim.keymap.set('n', 'grt', require('telescope.builtin').lsp_type_definitions, {
      buffer = event.buf,
      desc = 'LSP: [G]oto [T]ype Definition',
    })

    -- [[ Capabilities configuration ]]
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Highlight references
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
        end,
      })
    end

    -- Add inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, {
        buffer = event.buf,
        desc = 'LSP: [T]oggle Inlay [H]ints',
      })
    end
  end,
})

-- [[ Diagnostics configuration ]]
vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_lines = false,
  virtual_text = true,
})

-- Switch to virtual_lines via keymap, reset on moving cursor
vim.keymap.set('n', '<leader>k', function()
  vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
      return true
    end,
  })
end, { desc = '[k] Expand current line diagnostics' })

-- [[ LSP configuration ]]
local servers = {
  eslint = {},
  vtsls = {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server'),
              languages = { 'vue' },
              configNamespace = 'typescript',
            },
          },
        },
      },
    },
    filetypes = {
      'typescript',
      'javascript',
      'javascriptreact',
      'typescriptreact',
      'vue',
    },
  },
  vue_ls = {},
  graphql = {
    cmd = function(dispatchers, config)
      return vim.lsp.rpc.start({ 'graphql-lsp', 'server', '-m', 'stream', '-c', config.root_dir }, dispatchers, {
        cwd = config.cmd_cwd,
        env = config.cmd_env,
        detached = config.detached,
      })
    end,
    filetypes = { 'graphql', 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue' },
    settings = {},
  },
  rust_analyzer = {},
  powershell_es = {},
  emmet_language_server = {
    filetypes = { 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'pug', 'typescriptreact', 'vue' },
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  },
  helm_ls = {
    settings = {
      ['helm-ls'] = {
        yamlls = {
          path = vim.fn.expand('$MASON/bin/yaml-language-server'),
        },
      },
    },
  },
  yamlls = {},
  docker_language_server = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  cssls = {},
  jsonls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua',
  'prettierd',
  'markdownlint',
})

require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

for server_name, config in pairs(servers) do
  if not vim.tbl_isempty(config) then
    vim.lsp.config(server_name, config)
  end
end

require('mason-lspconfig').setup({
  ensure_installed = {},
  automatic_enable = true,
})
