-- Global variable to control format on save (default: true)
vim.g.format_on_save = true

return { -- Autoformat
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'

    -- LSP indent function (moved from misc.lua)
    local function lsp_indent()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd 'normal! ggVG='
      vim.api.nvim_win_set_cursor(0, pos)
    end

    conform.setup {
      notify_on_error = true,
      format_on_save = function(_bufnr)
        if not vim.g.format_on_save then
          return
        end

        -- rubocop does not auto indent
        if vim.bo.filetype == 'ruby' then
          lsp_indent()
        end

        return {
          lsp_format = 'fallback',
          timeout_ms = 3000,
        }
      end,

      formatters = {
        gotmplfmt = {
          command = 'gotmplfmt',
          args = { '-w', '80' },
        },

        rubocop = {
          args = { '-a', '-f', 'quiet', '--stderr', '--stdin', '$FILENAME' },
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
        templ = { 'templ' },
        css = { 'prettierd' },
        yml = { 'yamlfmt' },
        go = { 'goimports' },
        c = { 'clang-format' },
        xml = { 'xmlformatter' },
        ruby = { 'rubocop' },
        eruby = function(bufnr)
          if vim.api.nvim_buf_get_name(bufnr):match '%.html%.erb$' then
            return { 'erb_format' }
          end
          return {}
        end,
        gohtml = { 'gotmplfmt' },
        astro = { 'prettierd' },
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

    -- Manual format command
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

    -- Format keymap
    vim.keymap.set('n', '<leader>f', ':Format<cr>', { desc = 'Format', silent = true })
  end,
}
