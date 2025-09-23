local keymaps = require 'config.keymaps'

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

-- LSP Server Installation Instructions:
--
-- lua_ls (Lua Language Server):
--   npm install -g lua-language-server
--   OR: brew install lua-language-server
--   OR: pacman -S lua-language-server
--
-- ts_ls (TypeScript Language Server):
--   npm install -g typescript-language-server typescript
--
-- gopls (Go Language Server):
--   go install golang.org/x/tools/gopls@latest
--
-- ruby_lsp (Ruby Language Server):
--   gem install ruby-lsp
--
-- tailwindcss (Tailwind CSS Language Server):
--   npm install -g @tailwindcss/language-server
--
-- htmx (HTMX Language Server):
--   npm install -g htmx-lsp
--
-- yamlls (YAML Language Server):
--   npm install -g yaml-language-server
--
-- jsonls (JSON Language Server):
--   npm install -g vscode-langservers-extracted
--
-- cssls (CSS Language Server):
--   npm install -g vscode-langservers-extracted
--
-- bashls (Bash Language Server):
--   npm install -g bash-language-server
--
-- astro (Astro Language Server):
--   npm install -g @astrojs/language-server
--
-- eslint (ESLint Language Server):
--   npm install -g vscode-langservers-extracted

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
        keymaps.setKeymapsOnAttach(bufnr)
      end

      -- Configure language servers (extending built-in configurations)

      -- Lua Language Server - extend built-in config with custom settings
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

      -- TypeScript Language Server - extend with custom commands
      vim.lsp.config['ts_ls'] = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          attach_organize_imports(client, bufnr)

          keymaps.setTsKeymap(bufnr)
          on_attach(client, bufnr)
        end,
      }

      vim.lsp.config['tsgo'] = {
        capabilities = capabilities,
        cmd = { 'tsgo', '--lsp', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
        root_markers = {
          'tsconfig.json',
          'jsconfig.json',
          'package.json',
          '.git',
          'tsconfig.base.json',
        },
        on_attach = function(client, bufnr)
          keymaps.setTsKeymap(bufnr)
          on_attach(client, bufnr)
        end,
      }

      -- Go Language Server - extend with auto-format on save
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

      -- Ruby Language Server - extend with formatter config
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

      -- Tailwind CSS - extend with custom language mappings
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

      -- HTMX Language Server - extend with custom filetypes
      vim.lsp.config['htmx'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'html', 'templ' },
      }

      -- ESLint Language Server - custom configuration
      vim.lsp.config['eslint'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        filetypes = {},
        root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js', 'package.json' },
        settings = {},
      }

      -- Servers using default built-in configurations (minimal extension)
      for _, server in ipairs { 'yamlls', 'jsonls', 'cssls', 'bashls', 'astro' } do
        vim.lsp.config[server] = {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end

      -- Enable all configured language servers
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'ts_ls'
      -- vim.lsp.enable 'tsgo'
      vim.lsp.enable 'gopls'
      vim.lsp.enable 'ruby_lsp'
      vim.lsp.enable 'tailwindcss'
      vim.lsp.enable 'htmx'
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
}
