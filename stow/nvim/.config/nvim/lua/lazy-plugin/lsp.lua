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
      'williamboman/mason-lspconfig.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
        htmx = {
          filetypes = { 'html', 'templ' },
        },
        tailwindcss = {
          filetypes = { 'html', 'templ' },
          init_options = {
            userLanguages = {
              templ = 'html',
              html = 'html',
            },
          },
        },
        astro = {
          filetypes = { 'astro' },
        },
      }

      local on_attach = function(_, bufnr)
        SetKeymapsOnAttach(bufnr)
      end

      mason_lspconfig.setup {
        ensure_installed = {
          'ts_ls',
          'cssls',
          -- 'tailwindcss',
          'gopls',
          'bashls',
          'lua_ls',
          'jsonls',
          'yamlls',
        },
        automatic_installation = false, -- not the same as ensure_installed
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          local custom_capabilities = capabilities
          if server_name == 'eslint' then
            custom_capabilities = vim.lsp.protocol.make_client_capabilities()
            custom_capabilities.textDocument.codeAction = false
          end

          -- default
          lspconfig[server_name].setup {
            capabilities = custom_capabilities,
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)
            end,
            settings = servers[server_name],
          }

          lspconfig.ts_ls.setup {
            commands = {
              OrganizeImports = {
                function()
                  local params = {
                    command = '_typescript.organizeImports',
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = 'Organize Imports',
                  }
                  vim.lsp.buf.execute_command(params)
                end,
              },
            },
            capabilities = custom_capabilities,
            on_attach = function(client, bufnr)
              SetTsKeymap(bufnr)
              on_attach(client, bufnr)
            end,
          }

          lspconfig.gopls.setup {
            capabilities = custom_capabilities,
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
        end,
      }

      vim.diagnostic.config {
        underline = false,
      }

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = { spacing = 2 },
        signs = true,
        update_in_insert = false,
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded', -- You can use "single", "double", "rounded", "solid", or "shadow"
      })
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'prettier', -- prettier formatter
          'stylua', -- lua formatter
          -- 'eslint_d', -- eslint language server
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
