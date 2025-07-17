local keymaps = require 'config.keymaps'

return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup {
        ui = {
          border = 'rounded',
        },
      }
    end,
  },

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
        keymaps.setKeymapsOnAttach(bufnr)
      end

      -- Configure language servers
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
          vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
            local params = {
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = 'Organize Imports',
            }
            client:exec_cmd(params)
          end, { desc = 'Organize Imports' })

          keymaps.setTsKeymap(bufnr)
          on_attach(client, bufnr)
        end,
      }

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
        init_options = {
          formatter = 'auto',
        },
      }

      vim.lsp.config['tailwindcss'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          userLanguages = {
            templ = 'html',
            html = 'html',
          },
        },
      }

      vim.lsp.config['htmx'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'templ' },
      }

      -- Configure remaining servers with default config
      for _, server in ipairs { 'yamlls', 'jsonls', 'cssls', 'bashls' } do
        vim.lsp.config[server] = {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end

      -- Enable all configured language servers
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'ts_ls'
      vim.lsp.enable 'gopls'
      vim.lsp.enable 'ruby_lsp'
      vim.lsp.enable 'tailwindcss'
      vim.lsp.enable 'htmx'
      vim.lsp.enable 'yamlls'
      vim.lsp.enable 'jsonls'
      vim.lsp.enable 'cssls'
      vim.lsp.enable 'bashls'

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
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          -- Language servers (mason names)
          'typescript-language-server', -- ts_ls
          'css-lsp', -- cssls
          'gopls', -- gopls
          'bash-language-server', -- bashls
          'lua-language-server', -- lua_ls
          'json-lsp', -- jsonls
          'yaml-language-server', -- yamlls
          'tailwindcss-language-server', -- tailwindcss
          'ruby-lsp', -- ruby_lsp
          'htmx-lsp', -- htmx
          -- Tools
          'prettierd', -- prettier formatter
          'stylua', -- lua formatter
          'rubocop', -- ruby formatter
          'erb-lint', -- erb linter
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
}
