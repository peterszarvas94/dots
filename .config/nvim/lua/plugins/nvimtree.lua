return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      view = {
        width = '100%',
        relativenumber = true,
      },
      renderer = {
        icons = {
          git_placement = 'after',
          glyphs = {
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '',
              untracked = '+',
              deleted = '󰗨',
              ignored = '◌',
            },
          },
        },
        indent_markers = {
          enable = true,
          icons = {
            corner = '└',
            edge = '│',
            item = '├',
            bottom = '─',
            none = ' ',
          },
        },
      },
      disable_netrw = false,
      git = {
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      diagnostics = {
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    }
  end,
}
