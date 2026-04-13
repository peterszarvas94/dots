return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    local theme_state = _G.__rose_pine_mac_theme_state or {}
    _G.__rose_pine_mac_theme_state = theme_state

    local debug_log = vim.fn.stdpath 'state' .. '/theme-sync.log'

    local function log_debug(message)
      local ts = os.date '%Y-%m-%d %H:%M:%S'
      local sanitized = tostring(message):gsub('[%z\1-\31]', ' ')
      local line = ('[%s] %s'):format(ts, sanitized)
      pcall(vim.fn.writefile, { line }, debug_log, 'a')
    end

    log_debug 'theme config init'

    local function system_prefers_dark()
      local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
      if not handle then
        log_debug 'defaults popen failed, keeping previous background'
        return nil
      end

      local output = handle:read('*a') or ''
      local ok = handle:close()
      local trimmed = output:gsub('%s+$', '')

      if not ok then
        log_debug(('defaults close failed output=%q'):format(trimmed))
        return nil
      end

      if trimmed:match 'Dark' then
        log_debug(('defaults close_ok=%s output=%q theme=dark'):format(tostring(ok), trimmed))
        return true
      end

      if trimmed == '' then
        log_debug(('defaults close_ok=%s output=%q theme=light'):format(tostring(ok), trimmed))
        return false
      end

      log_debug(('defaults unexpected output=%q, keeping previous background'):format(trimmed))
      return nil
    end

    local current_background = nil

    local function sync_background(force)
      local prefers_dark = system_prefers_dark()
      local target_background = prefers_dark == nil and current_background or (prefers_dark and 'dark' or 'light')

      if not target_background then
        target_background = vim.o.background == 'light' and 'light' or 'dark'
      end

      log_debug(
        ('sync_background force=%s current=%s target=%s'):format(
          tostring(force),
          tostring(current_background),
          target_background
        )
      )

      if not force and current_background == target_background then
        log_debug 'sync skipped already in sync'
        return target_background, false
      end

      current_background = target_background
      vim.o.background = target_background
      local ok = pcall(vim.cmd.colorscheme, 'rose-pine')
      log_debug(('colorscheme apply ok=%s background=%s'):format(tostring(ok), target_background))
      return target_background, true
    end

    require('rose-pine').setup {
      variant = 'auto', -- auto, main, moon, or dawn
      dark_variant = 'main', -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },

      styles = {
        bold = false,
        italic = false,
        transparency = false,
      },

      groups = {
        border = 'muted',
        link = 'iris',
        panel = 'surface',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        note = 'pine',
        todo = 'rose',
        warn = 'gold',

        git_add = 'foam',
        git_change = 'rose',
        git_delete = 'love',
        git_dirty = 'rose',
        git_ignore = 'muted',
        git_merge = 'iris',
        git_rename = 'pine',
        git_stage = 'iris',
        git_text = 'rose',
        git_untracked = 'subtle',

        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
      },

      palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
      },

      -- NOTE: Highlight groups are extended (merged) by default. Disable this
      -- per group via `inherit = false`
      highlight_groups = {
        -- Comment = { fg = "foam" },
        -- StatusLine = { fg = "love", bg = "love", blend = 15 },
        -- VertSplit = { fg = "muted", bg = "muted" },
        -- Visual = { fg = "base", bg = "text", inherit = false },
      },

      before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
      end,
    }

    sync_background(true)
    log_debug 'initial sync done'

    vim.api.nvim_create_user_command('SyncTheme', function(opts)
      local target_background, changed = sync_background(opts.bang)
      local status = changed and 'updated' or 'already in sync'
      vim.notify(('Theme sync: %s (%s)'):format(target_background, status), vim.log.levels.INFO)
      log_debug(('SyncTheme command bang=%s status=%s'):format(tostring(opts.bang), status))
    end, {
      bang = true,
      desc = 'Sync Neovim theme with macOS appearance (! forces reload)',
    })

    pcall(vim.api.nvim_del_user_command, 'ThemeSyncDebugPath')
    vim.api.nvim_create_user_command('ThemeSyncDebugPath', function()
      vim.notify(('Theme sync log: %s'):format(debug_log), vim.log.levels.INFO)
      log_debug 'ThemeSyncDebugPath command invoked'
    end, {
      desc = 'Show macOS theme sync debug log path',
    })

    pcall(vim.api.nvim_del_user_command, 'ThemeSyncDebugStatus')
    vim.api.nvim_create_user_command('ThemeSyncDebugStatus', function()
      local msg = ('Theme sync status: background=%s'):format(
        tostring(vim.o.background)
      )
      vim.notify(msg, vim.log.levels.INFO)
      log_debug(msg)
    end, {
      desc = 'Show macOS theme sync status',
    })

    if vim.o.updatetime > 1000 then
      vim.o.updatetime = 1000
      log_debug 'set updatetime=1000 for CursorHold fallback'
    end

    vim.api.nvim_create_autocmd({
      'VimEnter',
      'FocusGained',
      'VimResume',
      'CursorHold',
      'CursorHoldI',
      'InsertLeave',
      'BufEnter',
    }, {
      group = vim.api.nvim_create_augroup('RosePineMacThemeSync', { clear = true }),
      callback = function()
        log_debug 'autocmd event fired'
        sync_background(false)
      end,
    })
  end,
}
