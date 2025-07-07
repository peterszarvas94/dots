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
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'ts_ls',
          'cssls',
          'gopls',
          'bashls',
          'lua_ls',
          'jsonls',
          'yamlls',
          'tailwindcss',
        },
        automatic_installation = false,
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local on_attach = function(_, bufnr)
        keymaps.setKeymapsOnAttach(bufnr)
      end

      -- Server configurations
      vim.lsp.config.lua_ls = {
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

      vim.lsp.config.ts_ls = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Create OrganizeImports command for this buffer
          vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
            local params = {
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = 'Organize Imports',
            }
            -- vim.lsp.buf.execute_command(params)
            client:exec_cmd(params)
          end, { desc = 'Organize Imports' })

          keymaps.setTsKeymap(bufnr)
          on_attach(client, bufnr)
        end,
      }

      vim.lsp.config.gopls = {
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

      vim.lsp.config.eslint = {
        autostart = false,
        -- capabilities = (function()
        --   local c = vim.lsp.protocol.make_client_capabilities()
        --   return c
        -- end)(),
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {}, -- Empty filetypes prevents auto-attachment
      }

      vim.lsp.config.cssls = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.config.tailwindcss = {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          userLanguages = {
            templ = 'html',
            html = 'html',
          },
        },
      }

      vim.lsp.config.htmx = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'templ' },
      }

      vim.lsp.config.astro = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.config.bashls = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.config.jsonls = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.config.yamlls = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
      })

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
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'prettierd', -- prettier formatter
          'stylua', -- lua formatter
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
