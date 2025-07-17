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
          'ruby_lsp',
          'solargraph',
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

      -- Global LSP configuration
      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua Language Server
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- TypeScript Language Server
      vim.lsp.config('ts_ls', {
        on_attach = function(client, bufnr)
          -- Create OrganizeImports command for this buffer
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
      })

      -- Go Language Server
      vim.lsp.config('gopls', {
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
      })

      -- Ruby Language Server
      vim.lsp.config('ruby_lsp', {
        init_options = {
          linters = { 'rubocop' },
          formatter = 'rubocop',
        },
      })

      -- ESLint (disabled by default)
      vim.lsp.config('eslint', {
        autostart = false,
        filetypes = {},
      })

      -- Tailwind CSS
      vim.lsp.config('tailwindcss', {
        init_options = {
          userLanguages = {
            templ = 'html',
            html = 'html',
          },
        },
      })

      -- HTMX Language Server
      vim.lsp.config('htmx', {
        filetypes = { 'html', 'templ' },
      })

      -- YAML Language Server
      vim.lsp.config('yamlls', {})

      -- JSON Language Server
      vim.lsp.config('jsonls', {})

      -- CSS Language Server
      vim.lsp.config('cssls', {})

      -- Bash Language Server
      vim.lsp.config('bashls', {})

      -- Enable language servers
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'ts_ls'
      vim.lsp.enable 'gopls'
      vim.lsp.enable 'ruby_lsp'
      vim.lsp.enable 'yamlls'
      vim.lsp.enable 'jsonls'
      vim.lsp.enable 'cssls'
      vim.lsp.enable 'bashls'
      vim.lsp.enable 'tailwindcss'
      vim.lsp.enable 'htmx'

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
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
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
