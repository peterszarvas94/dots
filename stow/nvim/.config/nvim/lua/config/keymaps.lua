-- Core Neovim keymaps (non-plugin specific)

-- unbind space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- source
vim.keymap.set('n', '<leader><leader>f', ':source %<CR>', { desc = 'Source File', silent = true })
vim.keymap.set('n', '<leader><leader>l', ':.lua<CR><CR>', { desc = 'Source Line(s)', silent = true })
vim.keymap.set('v', '<leader><leader>l', ':lua<CR><CR>', { desc = 'Source Line(s)', silent = true })

-- j->gj, k->gk
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostics list' })

-- tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Tab New', silent = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Tab Close', silent = true })
vim.keymap.set('n', '<leader>tw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'Toggle wrap', silent = true })

-- tmux
vim.keymap.set('n', '<leader>tm', ':Telescope tmux sessions<CR>', { desc = 'Tmux sessions', silent = true })

-- keep selection after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- quickfix list
vim.keymap.set('n', '<C-[>', ':cprevious<CR>', { desc = 'Previous item in quickfix list', silent = true })
vim.keymap.set('n', '<C-]>', ':cnext<CR>', { desc = 'Next item in quickfix list', silent = true })

-- split (M = alt or option, D = CMD on mac)
vim.keymap.set('n', '<M-.>', '<C-w>5>', { desc = 'Resize split +5 vertically', silent = true })
vim.keymap.set('n', '<M-,>', '<C-w>5<', { desc = 'Resize split -5 vertically', silent = true })
vim.keymap.set('n', '<M-=>', '<C-w>+', { desc = 'Resize split +1 horizontally', silent = true })
vim.keymap.set('n', '<M-->', '<C-w>-', { desc = 'Resize split -1 horizontally', silent = true })

-- buffer
vim.keymap.set('n', '<leader>y', 'ggVGy', { desc = 'Yank buffer', silent = true })
vim.keymap.set('n', '<leader>v', 'ggVG', { desc = 'Visual select buffer', silent = true })
vim.keymap.set('n', '<leader>p', 'ggVGp', { desc = 'Paste to buffer', silent = true })
