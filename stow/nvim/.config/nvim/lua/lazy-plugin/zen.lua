return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<leader>z', require('zen-mode').toggle, { desc = '[Z]en mode' })
  end
}
