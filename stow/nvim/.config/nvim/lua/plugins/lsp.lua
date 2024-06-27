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
          'tsserver',
          'cssls',
          'tailwindcss',
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
            },
          },
        },
        astro = {
          filetypes = { 'astro' },
        },
      }

      local on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
        vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
        vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]oto [D]eclaration' })
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })
      end

      local function organize_imports()
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
        }
        vim.lsp.buf.execute_command(params)
      end

      vim.api.nvim_create_user_command('OrganizeImports', function()
        organize_imports()
      end, {})

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = function()
              on_attach()
              require('which-key').register {
                ['<leader>'] = {
                  d = {
                    name = '[D]ocument',
                  },
                  r = {
                    name = '[R]e',
                  },
                  w = {
                    name = '[W]orkspace',
                  },
                },
              }
            end,
            settings = servers[server_name],
          }
        end,
      }

      -- diagnostics
      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable underline, it's very annoying
        underline = false,
        virtual_text = false,
        -- Enable virtual text, override spacing to 4
        virtual_text = {spacing = 4},
        -- Use a function to dynamically turn signs off
        -- and on, using buffer local variables
        signs = true,
        update_in_insert = false,
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
