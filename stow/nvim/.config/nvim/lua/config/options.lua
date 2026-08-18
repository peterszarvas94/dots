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
  -- require("config.remote_clipboard").setup()
end
vim.opt.relativenumber = false
vim.opt.hlsearch = false
-- Hide [current/total] search-count messages while keeping search navigation.
vim.opt.shortmess:append("S")
vim.opt.list = false

-- Keep Markdown source visible instead of concealing its formatting markers.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.opt.swapfile = false

vim.g.autoformat = true
vim.g.lazyvim_explorer = "neo-tree"

-- Do not show diagnostic icons in the signcolumn.
vim.diagnostic.config {
  signs = false,
  float = {
    border = "rounded",
  },
}
