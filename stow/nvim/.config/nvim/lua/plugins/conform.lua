-- Global variable to control format on save (default: true)
vim.g.format_on_save = true

return { -- Autoformat
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'

    conform.setup {
      notify_on_error = true,
      format_on_save = function(_bufnr)
        if not vim.g.format_on_save then
          return
        end

        -- require('config.misc').lsp_indent()

        return {
          lsp_format = 'fallback',
          timeout_ms = 500,
        }
      end,

      formatters = {
        gotmplfmt = {
          command = 'gotmplfmt',
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        json = { 'prettierd' },
        markdown = { 'prettierd' },
        html = { 'prettierd' },
        template = { 'gotmplfmt' },
        templ = { 'templ' },
        css = { 'prettierd' },
        yml = { 'yamlfmt' },
        go = { 'goimports' },
        c = { 'clang-format' },
        xml = { 'xmlformatter' },
        ruby = { 'rubocop' }, -- Or choose "rufo" if preferred
        eruby = { 'erb_format', 'erb_lint' }, -- Use 'eruby' for .erb files
      },
    }

    -- Commands to toggle format on save
    vim.api.nvim_create_user_command('FormatOnSaveToggle', function()
      vim.g.format_on_save = not vim.g.format_on_save
      print('Format on save: ' .. (vim.g.format_on_save and 'enabled' or 'disabled'))
    end, {})

    vim.api.nvim_create_user_command('FormatOnSaveDisable', function()
      vim.g.format_on_save = false
      print 'Format on save: disabled'
    end, {})

    vim.api.nvim_create_user_command('FormatOnSaveEnable', function()
      vim.g.format_on_save = true
      print 'Format on save: enabled'
    end, {})
  end,
}
