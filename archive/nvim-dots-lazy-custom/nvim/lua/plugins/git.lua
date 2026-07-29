return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = 'Git Diff', silent = true })
      vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git Blame', silent = true })
    end,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewClose',
      'DiffviewFileHistory',
      'DiffviewFocusFiles',
      'DiffviewLog',
      'DiffviewOpen',
      'DiffviewRefresh',
      'DiffviewToggleFiles',
    },
    config = function()
      require('diffview').setup {
        view = {
          merge_tool = {
            layout = 'diff4_mixed',
            winbar_info = true,
          },
        },
      }

      vim.keymap.set('n', '<leader>gD', ':DiffviewOpen<CR>', { desc = 'Diffview open', silent = true })
      vim.keymap.set('n', '<leader>gH', ':DiffviewFileHistory %<CR>', { desc = 'Diffview file history', silent = true })
      vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory<CR>', { desc = 'Diffview history', silent = true })
      vim.keymap.set('n', '<leader>gq', ':DiffviewClose<CR>', { desc = 'Diffview close', silent = true })
    end,
  },
}
