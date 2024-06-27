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
          name = '[C]...',
          h = '[C]ange C[H]eckbox',  
        },
        b = {
          name = '[O]bsidian',
        },
        s = {
          name = '[S]earch',
        },
        -- b = {
        --   name = '[B]uffer',
        -- },
        h = {
          name = '[H]arpoon',
        },
        t = {
          name = '[T]ab',
        },
        m = {
          name = '[M]arkdown',
        },
      },
    }
  end,
}
