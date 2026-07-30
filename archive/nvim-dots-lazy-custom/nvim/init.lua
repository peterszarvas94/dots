require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.highlights'

-- Bootstrap lazy.nvim
local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
local lazy_init = lazypath .. '/lua/lazy/init.lua'
if not uv.fs_stat(lazy_init) then
  if uv.fs_stat(lazypath) then
    vim.fn.delete(lazypath, 'rf')
  end

  local result = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }

  if vim.v.shell_error ~= 0 or not uv.fs_stat(lazy_init) then
    error(('Failed to bootstrap lazy.nvim at %s:\n%s'):format(lazypath, result))
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
local ok, lazy = pcall(require, 'lazy')
if not ok then
  error(('Failed to load lazy.nvim from %s:\n%s'):format(lazypath, lazy))
end

lazy.setup {
  spec = {
    import = 'plugins',
  },
  ui = {
    border = 'rounded',
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
