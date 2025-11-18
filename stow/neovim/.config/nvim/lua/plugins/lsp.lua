local function attach_organize_imports(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
    local params = {
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = 'Organize Imports',
    }
    client:exec_cmd(params)
  end, { desc = 'Organize Imports' })
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- Enable LSP logging for debugging
      -- vim.lsp.set_log_level('debug')

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local on_attach = function(_, bufnr)
        -- LSP keymaps
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto Definition' })
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = 'Goto References' })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Goto Implementation' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
      end

      vim.lsp.config['lua_ls'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      }

      vim.lsp.config['ts_ls'] = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          attach_organize_imports(client, bufnr)

          -- TypeScript specific keymaps
          vim.keymap.set('n', '<leader>oi', ':OrganizeImports<CR>', { buffer = bufnr, desc = 'Organize Imports' })

          on_attach(client, bufnr)
        end,
      }

      vim.lsp.config['denols'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'deno', 'lsp' },
      }

      -- vim.lsp.config['tsgo'] = {
      --   capabilities = capabilities,
      --   cmd = { 'tsgo', '--lsp', '--stdio' },
      --   filetypes = {
      --     'javascript',
      --     'javascriptreact',
      --     'javascript.jsx',
      --     'typescript',
      --     'typescriptreact',
      --     'typescript.tsx',
      --   },
      --   root_markers = {
      --     'tsconfig.json',
      --     'jsconfig.json',
      --     'package.json',
      --     '.git',
      --     'tsconfig.base.json',
      --   },
      --   on_attach = function(client, bufnr)
      --     -- TypeScript specific keymaps
      --     vim.keymap.set('n', '<leader>oi', ':OrganizeImports<CR>', { buffer = bufnr, desc = 'Organize Imports' })
      --
      --     on_attach(client, bufnr)
      --   end,
      -- }

      vim.lsp.config['gopls'] = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.g.gofmt_command = 'goimport'
          vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.go',
            callback = function()
              vim.cmd 'silent! lua vim.lsp.buf.format({ async = false })'
            end,
          })
          on_attach(client, bufnr)
        end,
      }

      vim.lsp.config['ruby_lsp'] = {
        cmd = { 'ruby-lsp' },
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'ruby', 'erb', 'eruby', 'rake', 'rakefile' },
        root_markers = { 'Gemfile', '.git' },
        init_options = {
          formatter = 'auto',
          linters = { 'rubocop' },
          enabledFeatures = {
            formatting = false,
            diagnostics = true,
          },
        },
      }

      vim.lsp.config['tailwindcss'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          userLanguages = {
            templ = 'html',
            html = 'html',
            eruby = 'html',
          },
        },
      }

      vim.lsp.config['htmx'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'templ' },
      }

      vim.lsp.config['eslint'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        filetypes = {},
        root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js', 'package.json' },
        settings = {},
      }

      for _, server in ipairs { 'yamlls', 'jsonls', 'cssls', 'bashls', 'astro', 'templ' } do
        vim.lsp.config[server] = {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end

      vim.lsp.enable 'lua_ls'

      local has_package_json = vim.fs.find('package.json', { upward = true, type = 'file' })[1]
      local has_deno_json = vim.fs.find({ 'deno.json', 'deno.jsonc' }, { upward = true, type = 'file' })[1]
      if has_package_json and not has_deno_json then
        vim.lsp.enable 'ts_ls'
      end
      if has_deno_json and not has_package_json then
        vim.lsp.enable 'denols'
      end

      -- vim.lsp.enable 'tsgo'
      vim.lsp.enable 'gopls'
      vim.lsp.enable 'ruby_lsp'
      vim.lsp.enable 'tailwindcss'
      vim.lsp.enable 'htmx'
      vim.lsp.enable 'templ'
      vim.lsp.enable 'yamlls'
      vim.lsp.enable 'jsonls'
      vim.lsp.enable 'cssls'
      vim.lsp.enable 'bashls'
      vim.lsp.enable 'astro'
      vim.lsp.enable 'eslint'

      -- LSP handlers configuration
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
      })

      -- Diagnostic configuration
      vim.diagnostic.config {
        signs = false,
        float = {
          border = 'rounded',
        },
        underline = {
          severity = {
            min = vim.diagnostic.severity.HINT,
          },
        },
        virtual_text = {
          current_line = true,
          prefix = function(diagnostic)
            local symbols = {
              [vim.diagnostic.severity.ERROR] = 'E',
              [vim.diagnostic.severity.WARN] = 'W',
              [vim.diagnostic.severity.INFO] = 'I',
              [vim.diagnostic.severity.HINT] = 'H',
            }
            return symbols[diagnostic.severity]
          end,
        },
      }
    end,
  },
  {
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup()
    end,
  },
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        -- LSPs
        'deno',

        'tailwindcss-language-server',
        'htmx-lsp',
        'templ',
        'yaml-language-server',
        'css-lsp',
        'json-lsp',
        'bash-language-server',
        'astro-language-server',
        'eslint-lsp',

        -- Formatters
        'stylua',
        'prettierd',
        'yamlfmt',
        'clang-format',
      },
      auto_update = true,
      run_on_start = true,
    },
  },
}
