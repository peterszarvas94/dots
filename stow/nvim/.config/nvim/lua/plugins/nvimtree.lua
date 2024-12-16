return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    local api = require 'nvim-tree.api'

    local function my_on_attach(bufnr)
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del('n', '<C-E>', { buffer = bufnr })
    end

    require('nvim-tree').setup {
      view = {
        width = 50,
        relativenumber = true,
        number = true,
        -- float = {
        --   enable = true,
        --   quit_on_focus_loss = true,
        --   open_win_config = {
        --     width = 55,
        --     height = vim.api.nvim_win_get_height(0) - 3,
        --     col = vim.api.nvim_win_get_width(0) - 30,
        --   },
        -- },
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
      -- update_focused_file = {
      --   enable = true,
      -- },
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
      on_attach = my_on_attach,
    }

    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd('edit ' .. file.fname)
    end)
  end,
}
