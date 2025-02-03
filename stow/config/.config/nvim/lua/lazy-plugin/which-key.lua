return {
  'folke/which-key.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local wk = require 'which-key'
    wk.setup {
      triggers = {
        { '<auto>', mode = '' },
      },
      border = 'rounded',
    }
    wk.add {
      { '<leader>o', group = '[O]bsitian / [O]rganize' },
      { '<leader>l', group = 'Conceal [L]evel' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = '[H]arpoon' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>n', group = '[N]vimTree' },
      { '<leader>t', group = '[T]ab / [T]erminal / [T]mux' },
      { '<leader>d', group = '[D]iagnostics' },
      { '<leader>m', group = '[M]arkdown' },
      { '<leader><leader>', group = 'Source' },
      { '<leader>r', group = '[R]e' },
    }
  end,
}
