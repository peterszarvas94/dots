vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- terminal
-- vim.keymap.set('n', '<leader>to', ':term<CR>', { desc = '[t]erminal [o]pen', silent = true })
-- vim.keymap.set('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- buffer
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', { desc = '[B]uffer [D]elete', silent = true })

-- explorer
-- vim.keymap.set('n', '<leader>x', ':Explore<cr>', { desc = 'E[x]plorer', silent = true })

-- undotree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr>', { desc = '[U]ndootree' })

-- keep selection after indent
vim.keymap.set({ 'v' }, '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
vim.keymap.set({ 'v' }, '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- organize imports
vim.keymap.set('n', '<leader>o', ':OrganizeImports<cr>', { desc = '[O]rganize Iports', silent = true })


-- quickfix list
vim.keymap.set('n', '<C-[>', '<cmd>cprevious<cr>', { desc = 'Previous item in quickfix list', silent = true })
vim.keymap.set('n', '<C-]>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix list', silent = true })

-- nvimtree
vim.keymap.set('n', '<leader>x', ':NvimTreeFindFileToggle<CR>', { desc = 'E[x]plorer toggle - Nvimtree', silent = true })
