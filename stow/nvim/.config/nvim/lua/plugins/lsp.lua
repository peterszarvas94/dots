return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'ibhagwan/fzf-lua',
    },
    config = function()
      if vim.fn.exists ':LspInfo' == 0 then
        vim.api.nvim_create_user_command('LspInfo', 'checkhealth lsp', {
          desc = 'Alias to `:checkhealth lsp`',
        })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local function has_executable(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local function enable_if_available(server, cmd)
        if has_executable(cmd) then
          vim.lsp.enable(server)
        end
      end

      local on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto Definition' })
        vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { buffer = bufnr, desc = 'Goto References' })
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Goto Implementation' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
      end

      vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
        if err or not (result and result.contents) then
          return
        end
        local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        lines = vim.lsp.util.trim_empty_lines(lines)
        if vim.tbl_isempty(lines) then
          return
        end
        return vim.lsp.util.open_floating_preview(
          lines,
          'plaintext',
          vim.tbl_extend('keep', config or {}, {
            border = 'rounded',
          })
        )
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

      -- TypeScript 7+ built-in LSP (`tsc --lsp --stdio`). Requires `tsc` on PATH.
      -- Install: npm install -g typescript@7
      -- If global install hits EACCES (prefix /usr): npm install -g typescript@7 --prefix ~/.local
      --   then: ln -sf ~/.local/lib/node_modules/typescript/bin/tsc ~/.local/bin/tsc
      vim.lsp.config['tsc'] = {
        capabilities = capabilities,
        cmd = { 'tsc', '--lsp', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        root_markers = {
          'package-lock.json',
          'yarn.lock',
          'pnpm-lock.yaml',
          'bun.lockb',
          'bun.lock',
          'package.json',
          'tsconfig.json',
          'jsconfig.json',
          '.git',
        },
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>oi', function()
            require('config.ts_lsp').organize_imports(bufnr)
          end, { buffer = bufnr, desc = 'Organize Imports' })

          on_attach(_, bufnr)
        end,
      }

      vim.lsp.config['gopls'] = {
        capabilities = capabilities,
        cmd = { 'gopls' },
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

      vim.lsp.config['templ'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'templ', 'lsp' },
        filetypes = { 'templ' },
        root_markers = { 'go.work', 'go.mod', '.git' },
      }

      vim.lsp.config['clangd'] = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.keymap.set('n', '<leader>ch', function()
            client:request('textDocument/switchSourceHeader', { uri = vim.uri_from_bufnr(bufnr) }, function(err, result)
              if err or not result then
                vim.notify('No corresponding source/header file found', vim.log.levels.INFO)
                return
              end
              vim.cmd.edit(vim.uri_to_fname(result))
            end, bufnr)
          end, { buffer = bufnr, desc = 'Switch Source/Header' })
          on_attach(client, bufnr)
        end,
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--fallback-style=llvm',
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        root_markers = {
          'compile_commands.json',
          'compile_flags.txt',
          '.clangd',
          'Makefile',
          '.git',
        },
      }

      vim.lsp.config['ols'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'ols' },
        filetypes = { 'odin' },
        root_markers = { 'ols.json', '.git' },
      }

      vim.lsp.config['rust_analyzer'] = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
      }

      for _, server in ipairs { 'yamlls', 'jsonls', 'cssls', 'bashls', 'astro' } do
        vim.lsp.config[server] = {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end

      enable_if_available('lua_ls', 'lua-language-server')
      enable_if_available('tsc', 'tsc')
      enable_if_available('gopls', 'gopls')
      enable_if_available('ruby_lsp', 'ruby-lsp')
      enable_if_available('templ', 'templ')
      enable_if_available('yamlls', 'yaml-language-server')
      enable_if_available('jsonls', 'vscode-json-language-server')
      enable_if_available('cssls', 'vscode-css-language-server')
      enable_if_available('bashls', 'bash-language-server')
      enable_if_available('astro', 'astro-ls')
      enable_if_available('ols', 'ols')
      enable_if_available('clangd', 'clangd')
      enable_if_available('rust_analyzer', 'rust-analyzer')

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
        'gopls',
        'templ',
        'yaml-language-server',
        'css-lsp',
        'json-lsp',
        'bash-language-server',
        'astro-language-server',
        'ols',
        'clangd',
        'rust-analyzer',
        'stylua',
        'yamlfmt',
        'clang-format',
      },
      auto_update = true,
      run_on_start = true,
    },
  },
}
