require('lualine').setup {
  options = {
    theme = 'tokyonight',
  },
}

vim.cmd 'colorscheme tokyonight-night'

require('which-key').register {
  ['<leader>'] = {
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
      name = '[T]erminal',
    },
  },
}
