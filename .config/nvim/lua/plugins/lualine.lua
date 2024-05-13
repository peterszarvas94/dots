return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            max_length = vim.o.columns,
            use_mode_colors = true,
            mode = 2,
            symbols = {
              modified = '',
            },
          },
        },
      },
      sections = {
        lualine_c = {},
      },
    }
  end,
}
