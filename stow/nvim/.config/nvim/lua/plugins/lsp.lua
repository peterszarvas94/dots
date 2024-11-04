return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'folke/which-key.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local lspconfig = require 'lspconfig'

      local mason_lspconfig = require 'mason-lspconfig'

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
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]ename' })
        vim.keymap.set('n', '<leader>i', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[I]mport / Code Actions' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
        -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
        -- vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
        -- vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
        -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]oto [D]eclaration' })
        -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
        -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
        -- vim.keymap.set('n', '<leader>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })
      end

      local ts_on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>oi', function()
          local params = {
            command = '_typescript.organizeImports',
            arguments = { vim.api.nvim_buf_get_name(0) },
            title = '',
          }
          vim.lsp.buf.execute_command(params)
        end, { buffer = bufnr, desc = '[O]rganize imports' })

        on_attach(_, bufnr)
      end

      mason_lspconfig.setup_handlers {
        function(server_name)
          local custom_capabilities = capabilities
          if server_name == 'eslint' then
            custom_capabilities = vim.lsp.protocol.make_client_capabilities()
            custom_capabilities.textDocument.codeAction = false
          end

          lspconfig[server_name].setup {
            capabilities = custom_capabilities,
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)
            end,
            settings = servers[server_name],
          }

          lspconfig.ts_ls.setup {
            capabilities = custom_capabilities,
            on_attach = function(client, bufnr)
              ts_on_attach(client, bufnr)
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
