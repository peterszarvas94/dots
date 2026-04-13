return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    local uv = vim.uv or vim.loop
    local state = _G.__rose_pine_mac_theme_state or {}
    _G.__rose_pine_mac_theme_state = state

    local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
    local theme_dir = vim.fn.fnamemodify(theme_file, ':h')
    local theme_name = vim.fn.fnamemodify(theme_file, ':t')
    local tmux_registry = vim.fn.stdpath 'state' .. '/theme-sync-tmux'

    local function read_lines(path)
      if vim.fn.filereadable(path) ~= 1 then
        return {}
      end

      local ok, lines = pcall(vim.fn.readfile, path)
      if not ok or type(lines) ~= 'table' then
        return {}
      end

      return lines
    end

    local function write_lines(path, lines)
      pcall(vim.fn.writefile, lines, path)
    end

    local function unique_lines(lines)
      local seen = {}
      local out = {}

      for _, line in ipairs(lines) do
        if line ~= '' and not seen[line] then
          seen[line] = true
          table.insert(out, line)
        end
      end

      return out
    end

    local function register_tmux_pane()
      local pane = vim.env.TMUX_PANE
      if not pane or pane == '' then
        return
      end

      local lines = read_lines(tmux_registry)
      local found = false
      for _, line in ipairs(lines) do
        if line == pane then
          found = true
          break
        end
      end

      if not found then
        table.insert(lines, pane)
      end

      write_lines(tmux_registry, unique_lines(lines))
    end

    local function unregister_tmux_pane()
      local pane = vim.env.TMUX_PANE
      if not pane or pane == '' then
        return
      end

      local lines = read_lines(tmux_registry)
      local keep = {}

      for _, line in ipairs(lines) do
        if line ~= pane then
          table.insert(keep, line)
        end
      end

      write_lines(tmux_registry, unique_lines(keep))
    end

    local function read_theme()
      local ok, data = pcall(dofile, theme_file)
      if not ok or type(data) ~= 'table' then
        return {
          background = 'dark',
          colorscheme = 'rose-pine',
        }
      end

      local background = data.background == 'light' and 'light' or 'dark'
      return {
        background = background,
        colorscheme = 'rose-pine',
      }
    end

    local function sync_theme(force)
      local theme = read_theme()
      local changed = force
        or state.background ~= theme.background
        or state.colorscheme ~= theme.colorscheme

      if not changed then
        return theme, false
      end

      state.background = theme.background
      state.colorscheme = theme.colorscheme

      vim.o.background = theme.background
      pcall(vim.cmd.colorscheme, theme.colorscheme)

      return theme, true
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

    sync_theme(true)
    register_tmux_pane()

    pcall(vim.api.nvim_del_user_command, 'SyncTheme')
    vim.api.nvim_create_user_command('SyncTheme', function(opts)
      local theme, changed = sync_theme(opts.bang)
      local status = changed and 'updated' or 'already in sync'
      vim.notify(('Theme sync: %s/%s (%s)'):format(theme.colorscheme, theme.background, status), vim.log.levels.INFO)
    end, {
      bang = true,
      desc = 'Sync Neovim theme from generated theme file (! forces reload)',
    })

    vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume', 'BufEnter' }, {
      group = vim.api.nvim_create_augroup('RosePineMacThemeSync', { clear = true }),
      callback = function()
        sync_theme(false)
        register_tmux_pane()
      end,
    })

    if uv and uv.new_fs_event then
      if state.watcher and not state.watcher:is_closing() then
        state.watcher:stop()
        state.watcher:close()
        state.watcher = nil
      end

      local watcher = uv.new_fs_event()
      local ok = watcher:start(theme_dir, {}, vim.schedule_wrap(function(err, fname)
        if err then
          return
        end
        if fname and fname ~= theme_name then
          return
        end
        if vim.v.exiting == 0 then
          sync_theme(false)
        end
      end))

      if ok then
        state.watcher = watcher
      elseif watcher and not watcher:is_closing() then
        watcher:close()
      end
    end

    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = vim.api.nvim_create_augroup('RosePineMacThemeSyncCleanup', { clear = true }),
      callback = function()
        unregister_tmux_pane()
        if state.watcher and not state.watcher:is_closing() then
          state.watcher:stop()
          state.watcher:close()
          state.watcher = nil
        end
      end,
    })
  end,
}
