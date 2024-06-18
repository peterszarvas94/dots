return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 50,
        relativenumber = true,
        number = true,
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
      update_focused_file = {
        enable = true,
      },
      modified = {
        enable = true,
      },
      filters = {
        enable = true,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
    }

    local api = require 'nvim-tree.api'
    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd('edit ' .. file.fname)
    end)
  end,
}
