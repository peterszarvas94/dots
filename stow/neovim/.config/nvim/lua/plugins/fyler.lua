return {
  'A7Lavinraj/fyler.nvim',
  dependencies = { 'nvim-mini/mini.icons' },
  branch = 'stable', -- Use stable branch for production
  lazy = false, -- Necessary for `default_explorer` to work properly
  config = function()
    local fyler = require 'fyler'

    fyler.setup {
      hooks = {},
      integrations = {
        icon = 'mini_icons',
      },
      views = {
        finder = {
          close_on_select = false,
          confirm_simple = false,
          default_explorer = true,
          delete_to_trash = false,
          git_status = {
            enabled = true,
            symbols = {
              Untracked = '+',
              Added = '✓',
              Modified = '*',
              Deleted = '󰗨',
              Renamed = '󰁔',
              Copied = '~',
              Conflict = '',
              Ignored = '◌',
            },
          },
          icon = {
            directory_collapsed = '',
            directory_empty = '',
            directory_expanded = '',
          },
          indentscope = {
            enabled = true,
            group = 'FylerIndentMarker',
            marker = '│',
          },
          mappings = {
            ['q'] = 'CloseView',
            ['<CR>'] = 'Select',
            ['<C-t>'] = 'SelectTab',
            ['|'] = 'SelectVSplit',
            ['-'] = 'SelectSplit',
            ['^'] = 'GotoParent',
            ['='] = 'GotoCwd',
            ['.'] = 'GotoNode',
            ['#'] = 'CollapseAll',
            ['<BS>'] = 'CollapseNode',
          },
          mappings_opts = {
            nowait = false,
            noremap = true,
            silent = true,
          },
          follow_current_file = true,
          watcher = {
            enabled = true,
          },
          win = {
            border = vim.o.winborder == '' and 'single' or vim.o.winborder,
            buf_opts = {
              filetype = 'fyler',
              syntax = 'fyler',
              buflisted = false,
              buftype = 'acwrite',
              expandtab = true,
              shiftwidth = 2,
            },
            kind = 'split_left_most',
            kinds = {
              float = {
                height = '70%',
                width = '70%',
                top = '10%',
                left = '15%',
              },
              replace = {},
              split_above = {
                height = '70%',
              },
              split_above_all = {
                height = '70%',
                win_opts = {
                  winfixheight = true,
                },
              },
              split_below = {
                height = '70%',
              },
              split_below_all = {
                height = '70%',
                win_opts = {
                  winfixheight = true,
                },
              },
              split_left = {
                width = '30%',
              },
              split_left_most = {
                width = '30%',
                win_opts = {
                  winfixwidth = true,
                },
              },
              split_right = {
                width = '30%',
              },
              split_right_most = {
                width = '30%',
                win_opts = {
                  winfixwidth = true,
                },
              },
            },
            win_opts = {
              concealcursor = 'nvic',
              conceallevel = 3,
              cursorline = false,
              number = false,
              relativenumber = false,
              winhighlight = 'Normal:FylerNormal,NormalNC:FylerNormalNC',
              wrap = false,
              signcolumn = 'no',
            },
          },
        },
      },
    }

    vim.keymap.set('n', '<leader>x', function()
      fyler.toggle()
    end, { desc = 'Fyler Toggle', silent = true })
  end,
}
