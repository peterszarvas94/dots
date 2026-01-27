return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = 'Git Diff', silent = true })
    vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git Blame', silent = true })
  end,
}
