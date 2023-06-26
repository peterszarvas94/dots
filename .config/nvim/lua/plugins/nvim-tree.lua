return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = function()
    require("nvim-tree").setup({ -- BEGIN_DEFAULT_OPTS
      view = {
        hide_root_folder = false,
      },
      filters = {
        dotfiles = false,
      },
    }) -- END_DEFAULT_OPTS
  end
}
