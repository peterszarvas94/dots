return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    local POLL_INTERVAL_MS = 2000

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

    vim.api.nvim_create_user_command('SyncTheme', function(opts)
      local target_background, changed = sync_background(opts.bang)
      local status = changed and 'updated' or 'already in sync'
      vim.notify(('Theme sync: %s (%s)'):format(target_background, status), vim.log.levels.INFO)
    end, {
      bang = true,
      desc = 'Sync Neovim theme with macOS appearance (! forces reload)',
    })

    vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume' }, {
      group = vim.api.nvim_create_augroup('RosePineMacThemeSync', { clear = true }),
      callback = function()
        sync_background(false)
      end,
    })

    local timer = vim.uv.new_timer()
    if timer then
      timer:start(
        POLL_INTERVAL_MS,
        POLL_INTERVAL_MS,
        vim.schedule_wrap(function()
          if vim.v.exiting == 0 then
            sync_background(false)
          end
        end)
      )

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup('RosePineMacThemeSyncTimer', { clear = true }),
        callback = function()
          if not timer:is_closing() then
            timer:stop()
            timer:close()
          end
        end,
      })
    end
  end,
}
