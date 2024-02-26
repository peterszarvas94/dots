return {
  "folke/zen-mode.nvim",
  config = function()
    local zenmode = require 'zen-mode'
    vim.keymap.set('n', '<leader>z', zenmode.toggle, { desc = '[Z]en mode' })
  end
}
