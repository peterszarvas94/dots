return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'folke/neodev.nvim',
  },
  config = function()
    local mason = require 'mason'
    local mason_lspconfig = require 'mason-lspconfig'
    local mason_tool_installer = require 'mason-tool-installer'

    mason.setup {}

    mason_lspconfig.setup {
      ensure_installed = {
        'tsserver', -- typescript language server
        'cssls', -- css language server
        'tailwindcss', -- tailwindcss language server
        'gopls', -- go language server
        'bashls', -- bash language server
        'lua_ls', -- lua language server
        'jsonls', -- json language server
      },
      automatic_installation = false, -- not the same as ensure_installed
    }

    mason_tool_installer.setup {
      ensure_installed = {
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
        -- 'eslint_d', -- eslint language server
      },
    }
  end,
}
