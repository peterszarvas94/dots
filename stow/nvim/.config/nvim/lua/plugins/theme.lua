local function fallback_rose_pine()
  return {
    {
      'rose-pine/neovim',
      name = 'rose-pine',
    },
    {
      'LazyVim/LazyVim',
      opts = {
        colorscheme = 'rose-pine',
      },
    },
  }
end

local function running_on_macos()
  local uv = vim.uv or vim.loop
  return uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'
end

if running_on_macos() then
  local mac_theme_file = vim.fn.stdpath 'config' .. '/mac/theme.lua'
  local ok, spec = pcall(dofile, mac_theme_file)
  if ok then
    return spec
  end

  vim.notify('Failed to load macOS Neovim theme, falling back to rose-pine', vim.log.levels.WARN)
  return fallback_rose_pine()
end

local omarchy_theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, spec = pcall(dofile, omarchy_theme_file)
if ok and type(spec) == 'table' then
  return spec
end

vim.notify('Failed to load Omarchy Neovim theme, falling back to rose-pine', vim.log.levels.WARN)
return fallback_rose_pine()
