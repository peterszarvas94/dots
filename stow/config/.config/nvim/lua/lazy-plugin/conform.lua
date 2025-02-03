return { -- Autoformat
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'
    conform.setup {
      notify_on_error = true,
      format_on_save = {
        lsp_format = 'fallback',
        timeout_ms = 500,
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
        templ = { 'templ' },
        css = { 'prettierd' },
        yml = { 'prettierd' },
        go = { 'goimports' },
        c = { 'clang-format' },
      },
    }
  end,
}
