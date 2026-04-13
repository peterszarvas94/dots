local function fallback_theme()
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
    },
    {
      'LazyVim/LazyVim',
      opts = {
        colorscheme = 'rose-pine',
      },
    },
  }
end

local function load_theme_file(path)
  local ok, spec = pcall(dofile, path)
  if ok and type(spec) == 'table' then
    return spec
  end
  return nil
end

local uv = vim.uv or vim.loop
local is_macos = uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'

if is_macos then
  local mac_spec = load_theme_file(vim.fn.stdpath 'config' .. '/mac/theme.lua')
  if mac_spec then
    return mac_spec
  end
end

local omarchy_spec = load_theme_file(vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua')
if omarchy_spec then
  return omarchy_spec
end

vim.notify('Failed to load theme file, using rose-pine fallback', vim.log.levels.WARN)
return fallback_theme()
