-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.fn.has("macunix") == 1 then
  vim.opt.clipboard = "unnamedplus"
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      vim.opt.clipboard = "unnamedplus"
    end,
  })
else
  require("config.remote_clipboard").setup()
end
vim.opt.relativenumber = false
vim.opt.hlsearch = false
vim.opt.shortmess:append("S")
vim.opt.list = false

-- Keep swap files in a user-owned directory. The old directory was created as
-- root and causes E303 when opening files.
local swap_dir = vim.fn.stdpath("state") .. "/swap-peti"
vim.fn.mkdir(swap_dir, "p", 448) -- 0700
vim.opt.directory = swap_dir .. "//"

vim.g.autoformat = true
