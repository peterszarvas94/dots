local function running_on_macos()
  local uv = vim.uv or vim.loop
  return uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'
end

local function rose_pine_spec()
  return {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
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
      }
    end,
  }
end

local function runtime_spec(name, events, user_pattern)
  return {
    name = 'theme-runtime',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      require('config.theme.runtime').setup {
        name = name,
        theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua',
        fallback = {
          background = 'dark',
          colorscheme = 'rose-pine',
        },
        watch_file = true,
        events = events,
        user_pattern = user_pattern,
        command_name = 'SyncTheme',
        command_desc = 'Reload Neovim theme from generated theme file',
      }
    end,
  }
end

local function fallback_rose_pine(platform_name)
  return {
    rose_pine_spec(),
    {
      'LazyVim/LazyVim',
      opts = {
        colorscheme = 'rose-pine',
      },
    },
    runtime_spec(platform_name, { 'VimEnter', 'FocusGained', 'VimResume', 'BufEnter' }),
  }
end

if running_on_macos() then
  return fallback_rose_pine 'mac'
end

local omarchy_theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, spec = pcall(dofile, omarchy_theme_file)
if ok and type(spec) == 'table' then
  table.insert(spec, runtime_spec('omarchy', { 'VimEnter', 'FocusGained', 'VimResume' }, 'LazyReload'))
  return spec
end

vim.notify('Failed to load Omarchy Neovim theme, falling back to rose-pine', vim.log.levels.WARN)
return fallback_rose_pine 'omarchy'
