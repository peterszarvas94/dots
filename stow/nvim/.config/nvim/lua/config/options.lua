vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'
-- vim.o.guicursor = 'n-v-c:block'
vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true
vim.o.signcolumn = 'yes'
vim.o.colorcolumn = ''
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
-- vim.opt.showtabline = 2
vim.g.netrw_liststyle = 0
vim.o.scrolloff = 8
vim.o.inccommand = 'split'
vim.o.swapfile = false
vim.o.wrap = true
-- vim.o.ignorecase = false
-- vim.o.smartcase = false
-- vim.o.conceallevel = 2
-- vim.o.breakindent = true
-- vim.o.updatetime = 250
-- vim.o.timeout = true
vim.o.timeoutlen = 1000
-- vim.o.completeopt = 'menuone,noselect'
vim.o.winborder = 'rounded'
-- vim.opt.winbar = '%f %h%w%m%r%= %l:%c %p%%'

-- neovide
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_trail_size = 0.03
  vim.o.guifont = 'MesloLGS Nerd Font Mono'
end

vim.cmd.colorscheme 'default'
-- vim.opt.background = 'light'
vim.opt.background = 'dark'
