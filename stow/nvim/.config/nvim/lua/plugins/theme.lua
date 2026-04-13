local function running_on_macos()
  local uv = vim.uv or vim.loop
  return uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'
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
        lock_colorscheme = 'rose-pine',
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
    {
      'rose-pine/neovim',
      name = 'rose-pine',
      config = function()
        require('rose-pine').setup {
          styles = {
            italic = false,
            bold = false,
          },
        }
      end,
      priority = 1000,
      lazy = true,
    },
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

return fallback_rose_pine 'omarchy'
