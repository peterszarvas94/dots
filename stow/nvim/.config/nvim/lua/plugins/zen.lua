return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<leader>z', require('zen-mode').toggle, { desc = '[Z]en mode' })

    require('zen-mode').setup {
      window = {
        options = {
          winbar = '',
        }
      },
      plugins = {
        options = {
          ruler = false,
          showcmd = false,
        },
      },
      on_open = function(win) 
        vim.api.nvim_win_set_config(win, { border = 'none' })
        -- Also set border to none and transparent background for zen-mode floating windows
        vim.schedule(function()
          for _, winid in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(winid)
            if config.relative ~= '' then
              vim.api.nvim_win_set_config(winid, vim.tbl_extend('force', config, { border = 'none' }))
              vim.api.nvim_win_set_option(winid, 'winblend', 0)
              vim.api.nvim_win_set_option(winid, 'winhighlight', 'Normal:Normal,NormalFloat:Normal')
            end
          end
        end)
      end,
      on_close = function() end,
    }
  end,
}
