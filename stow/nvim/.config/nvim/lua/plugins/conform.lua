return { -- Autoformat
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'
    conform.setup {
      format_on_save = false,
      notify_on_error = true,
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

    -- Format on save
    local format_in_progress = false

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
      callback = function()
        if format_in_progress then
          return
        end
        format_in_progress = true

        vim.cmd 'OrganizeImports'

        vim.defer_fn(function()
          vim.cmd 'Format'
          vim.schedule(function()
            vim.cmd 'write'
            format_in_progress = false
          end)
        end, 200)
        return true -- Cancel the original write
      end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*' },
      callback = function()
        if format_in_progress then
          return
        end
        format_in_progress = true

        vim.cmd 'Format'
      end,
    })
  end,
}
