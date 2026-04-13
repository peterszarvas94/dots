local uv = vim.uv or vim.loop
local is_macos = uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'

if is_macos then
  return {}
end

local omarchy_preload_file = vim.fn.stdpath 'config' .. '/omarchy/omarchy-theme-preload.lua'
local ok, spec = pcall(dofile, omarchy_preload_file)
if ok and type(spec) == 'table' then
  return spec
end

vim.notify('Failed to load Omarchy theme preload', vim.log.levels.WARN)
return {}
