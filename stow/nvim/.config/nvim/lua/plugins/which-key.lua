return {
  'folke/which-key.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require('which-key').add {
      { '<leader>b', group = '[O]bsidian' },
      { '<leader>c', group = '[C]...' },
      { '<leader>ch', desc = '[C]ange C[H]eckbox' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = '[H]arpoon' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]ab' },
    }
  end,
}
