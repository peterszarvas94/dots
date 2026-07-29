-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Buffer-wide edit helpers (<leader>Y/D/V/P are free; lowercase <leader>d = debug, <leader>p = yanky if enabled)
map("n", "<leader>Y", ":%y<CR>", { desc = "Yank entire buffer" })
map("n", "<leader>D", ":%d<CR>", { desc = "Delete entire buffer" })
map("n", "<leader>V", "ggVG", { desc = "Select entire buffer" })
map("n", "<leader>P", "ggVGp", { desc = "Paste over entire buffer" })
