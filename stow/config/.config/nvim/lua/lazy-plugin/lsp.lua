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
      'williamboman/mason-lspconfig.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local on_attach = function(_, bufnr)
        keymaps.setKeymapsOnAttach(bufnr)
      end

      local servers = {
        eslint = {
          autostart = false,
          capabilities = (function()
            local c = vim.lsp.protocol.make_client_capabilities()
            c.textDocument.codeAction = nil
            return c
          end)(),
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },
        htmx = {
          settings = {
            filetypes = { 'html', 'templ' },
          },
        },
        cssls = {
          settings = {
            filetypes = { 'css', 'html', 'templ' },
          },
        },
        tailwindcss = {
          settings = {
            filetypes = { 'html', 'templ' },
            init_options = {
              userLanguages = {
                templ = 'html',
                html = 'html',
              },
            },
          },
        },
        astro = {
          settings = {
            filetypes = { 'astro' },
          },
        },
        ts_ls = {
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
          on_attach = function(client, bufnr)
            SetTsKeymap(bufnr)
            on_attach(client, bufnr)
          end,
        },
        gopls = {
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
        },
      }

      mason_lspconfig.setup {
        ensure_installed = {
          'ts_ls',
          'cssls',
          'eslint',
          'gopls',
          'bashls',
          'lua_ls',
          'jsonls',
          'yamlls',
          'tailwindcss',
        },
        automatic_installation = false, -- not the same as ensure_installed
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          local config = servers[server_name] or {}

          lspconfig[server_name].setup {
            autostart = config.autostart ~= false,
            capabilities = config.capabilities or capabilities,
            on_attach = config.on_attach or on_attach,
            settings = config.settings,
            commands = config.commands,
          }
        end,
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
