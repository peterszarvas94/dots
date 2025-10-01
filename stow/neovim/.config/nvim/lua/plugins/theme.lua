return {
  --   { 'neanias/everforest-nvim' },
  --   {
  --     'LazyVim/LazyVim',
  --     opts = {
  --       colorscheme = 'everforest',
  --       background = 'soft',
  --     },
  --   },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        integrations = {
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = {},
              hints = {},
              warnings = {},
              information = {},
            },
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
          },
        },
      }
    end,
  },
  {
    -- for the fake lazyvim integration in omarchy
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'catppuccin',
    },
  },
}
