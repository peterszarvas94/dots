return {
  'folke/which-key.nvim',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require('which-key').register {
      ['<leader>'] = {
        c = {
          name = '[C]ode / [C]olorizer',
        },
        g = {
          name = '[G]it',
        },
        s = {
          name = '[S]earch',
        },
        b = {
          name = '[B]uffer',
        },
        h = {
          name = '[H]arpoon',
        },
        t = {
          name = '[T]ab'
        },
        m = {
          name = '[M]arkdown'
        },
      },
    }
  end,
}
