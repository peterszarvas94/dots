return {
  {
    'wallpants/github-preview.nvim',
    config = function()
      require('github-preview').setup {
        host = 'localhost',
        port = 6041,
      }

      -- GitHub Preview keymaps
      vim.keymap.set('n', '<leader>ms', ':GithubPreviewStart<CR>', { desc = 'Markdown Start', silent = true })
      vim.keymap.set('n', '<leader>mp', ':GithubPreviewStop<CR>', { desc = 'Markdown stoP', silent = true })
      vim.keymap.set('n', '<leader>mt', ':GithubPreviewToggle<CR>', { desc = 'Markdown Toggle', silent = true })
    end,
  },
}
