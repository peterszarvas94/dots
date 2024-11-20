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
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
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
      },
    }

    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      conform.format { async = false, lsp_fallback = true, range = range }
    end, { range = true })

    vim.keymap.set('n', '<leader>f', '<cmd>Format<cr>', { desc = '[F]ormat', silent = true })
  end,
}
