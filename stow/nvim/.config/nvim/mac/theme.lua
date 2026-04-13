return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    local uv = vim.uv or vim.loop
    local POLL_INTERVAL_MS = 2000
    local sync_group = vim.api.nvim_create_augroup('RosePineMacThemeSync', { clear = true })
    local timer_group = vim.api.nvim_create_augroup('RosePineMacThemeSyncTimer', { clear = true })

    local function system_prefers_dark()
      local output = vim.fn.system { 'defaults', 'read', '-g', 'AppleInterfaceStyle' }
      return vim.v.shell_error == 0 and output:match 'Dark' ~= nil
    end

    local current_background = nil

    local function sync_background(force)
      local target_background = system_prefers_dark() and 'dark' or 'light'

      if not force and current_background == target_background then
        return target_background, false
      end

      current_background = target_background
      vim.o.background = target_background
      pcall(vim.cmd.colorscheme, 'rose-pine')
      return target_background, true
    end

    require('rose-pine').setup {
      variant = 'auto',
      dark_variant = 'main',
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = false,
        italic = false,
        transparency = false,
      },
    }

    sync_background(true)

    pcall(vim.api.nvim_del_user_command, 'SyncTheme')
    vim.api.nvim_create_user_command('SyncTheme', function(opts)
      local target_background, changed = sync_background(opts.bang)
      local status = changed and 'updated' or 'already in sync'
      vim.notify(('Theme sync: %s (%s)'):format(target_background, status), vim.log.levels.INFO)
    end, {
      bang = true,
      desc = 'Sync Neovim theme with macOS appearance (! forces reload)',
    })

    vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume' }, {
      group = sync_group,
      callback = function()
        sync_background(false)
      end,
    })

    local uv_timer = uv and uv.new_timer and uv.new_timer() or nil
    if uv_timer then
      uv_timer:start(
        POLL_INTERVAL_MS,
        POLL_INTERVAL_MS,
        vim.schedule_wrap(function()
          if vim.v.exiting == 0 then
            sync_background(false)
          end
        end)
      )

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = timer_group,
        callback = function()
          if not uv_timer:is_closing() then
            uv_timer:stop()
            uv_timer:close()
          end
        end,
      })
      return
    end

    local fallback_timer = vim.fn.timer_start(POLL_INTERVAL_MS, function()
      if vim.v.exiting == 0 then
        sync_background(false)
      end
    end, { ['repeat'] = -1 })

    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = timer_group,
      callback = function()
        pcall(vim.fn.timer_stop, fallback_timer)
      end,
    })
  end,
}
