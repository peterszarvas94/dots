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
      git = {
        ignore = false
      },
      renderer = {
        icons = {
          webdev_colors = true,
          git_placement = "after",
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
            modified = true,
          },
          glyphs = {
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
    }) -- END_DEFAULT_OPTS
  end
}
