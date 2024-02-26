return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'folke/neodev.nvim',
  },
  config = function()
    require('neodev').setup()
  end,
}
