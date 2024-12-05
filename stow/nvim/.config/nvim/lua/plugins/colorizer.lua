return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      AARRGGBB = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      mode = 'background',
      tailwind = true,
      virtualtext = '■',
      always_update = false,
    }

    vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = '*',
      callback = function()
        vim.cmd 'ColorizerDetachFromBuffer'
      end,
    })
  end,
}
