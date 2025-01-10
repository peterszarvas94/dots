return {
  dir = vim.fn.expand '~' .. '/projects/live-reload.nvim/',
  -- 'peterszarvas94/live-reload.nvim',
  dependencies = {
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8' },
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('live-reload').setup {}

    vim.keymap.set('n', '<leader>ls', ':LiveReloadStart<CR>', { desc = '[L]ive reload [S]tart', silent = true })
    vim.keymap.set('n', '<leader>lt', ':LiveReloadState<CR>', { desc = '[L]ive reload s[T]ate', silent = true })
    vim.keymap.set('n', '<leader>lb', ':LiveReloadBuffers<CR>', { desc = '[L]ive reload [B]uffers', silent = true })
    vim.keymap.set('n', '<leader>lp', ':LiveReloadStop<CR>', { desc = '[L]ive reload sto[P]', silent = true })
    vim.keymap.set('n', '<leader>l1', ':LiveReloadShow 1<CR>', { desc = '[L]ive reload show [1]', silent = true })
    vim.keymap.set('n', '<leader>l2', ':LiveReloadShow 2<CR>', { desc = '[L]ive reload show [2]', silent = true })
    vim.keymap.set('n', '<leader>l3', ':LiveReloadShow 3<CR>', { desc = '[L]ive reload show [3]', silent = true })
    vim.keymap.set('n', '<leader>l4', ':LiveReloadShow 4<CR>', { desc = '[L]ive reload show [4]', silent = true })
  end,
}
