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
      { '<leader>o', group = '[O]bsitian / [O]rganize' },
      { '<leader>l', group = 'Conceal [L]evel' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = '[H]arpoon' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]ab / [T]erminal' },
      { '<leader>d', group = '[D]iagnostics' },
      { '<leader>m', group = '[M]arkdown' },
      { '<leader><leader>', group = 'Source' },
      { '<leader>r', group = '[R]e' },
    }
  end,
}
