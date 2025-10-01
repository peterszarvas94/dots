return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    local api = require 'nvim-tree.api'

    local function my_on_attach(bufnr)
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del('n', '<C-E>', { buffer = bufnr })
      vim.keymap.set('n', '<C-[>', api.tree.change_root_to_parent, { buffer = bufnr }, 'CD ..')
      vim.cmd 'ColorizerDetachFromBuffer'
    end

    require('nvim-tree').setup {
      view = {
        -- width = {
        --   min = 50,
        -- },
        width = 70,
        -- width = 50,
        -- side = 'right',
        side = 'left',
        relativenumber = false,
        number = true,
        -- separator = '│',
        float = {
          enable = false,
          -- enable = true,
          quit_on_focus_loss = false,
          open_win_config = {
            width = 75,
            height = vim.api.nvim_win_get_height(0) - 3,
            col = vim.api.nvim_win_get_width(0) - 30,
          },
        },
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
            -- corner = '└',
            -- edge = '│',
            -- item = '├',
            -- bottom = '─',
            -- none = ' ',
            corner = ' ',
            edge = ' ',
            item = ' ',
            bottom = ' ',
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
        git_ignored = true,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
      actions = {
        file_popup = {
          open_win_config = {
            border = 'rounded',
          },
        },
      },
      on_attach = my_on_attach,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
    }

    -- api.events.subscribe(api.events.Event.FileCreated, function(file)
    --   vim.cmd('edit ' .. file.fname)
    -- end)
  end,
}
