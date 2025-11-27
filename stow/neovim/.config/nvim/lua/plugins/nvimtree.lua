return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    local api = require 'nvim-tree.api'

    local function my_on_attach(bufnr)
      api.config.mappings.default_on_attach(bufnr)
      -- Remove change root keymaps
      vim.keymap.del('n', '<C-E>', { buffer = bufnr }) -- Remove "Open: In Place"
      vim.keymap.del('n', '<C-]>', { buffer = bufnr }) -- Remove "CD" (change root to node)
      vim.keymap.del('n', '-', { buffer = bufnr }) -- Remove "Up" (change root to parent)
      vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr }) -- Remove right-click CD

      -- Override Enter to block parent directory navigation
      vim.keymap.del('n', '<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<CR>', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.name == '..' then
          return -- Block navigation to parent
        end
        api.node.open.edit()
      end, { buffer = bufnr, desc = 'Open (no parent)' })

      vim.cmd 'ColorizerDetachFromBuffer'
    end

    require('nvim-tree').setup {
      view = {
        width = 70,
        side = 'left',
        relativenumber = false,
        number = true,
        float = {
          enable = false,
          quit_on_focus_loss = false,
          open_win_config = {
            width = 75,
            height = vim.api.nvim_win_get_height(0) - 3,
            col = vim.api.nvim_win_get_width(0) - 30,
          },
        },
      },
      renderer = {
        root_folder_label = ':t', -- Show only folder name, not parent path
        icons = {
          git_placement = 'after',
          glyphs = {
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '',
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
        enable = false,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
      actions = {
        change_dir = {
          enable = false, -- Completely disable changing directories
          restrict_above_cwd = true, -- Extra protection
        },
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

    -- NvimTree keymaps
    vim.keymap.set('n', '<leader>x', ':NvimTreeToggle<CR>', { desc = 'NvimTree Toggle', silent = true })
    vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { desc = 'NvimTree Find file', silent = true })
  end,
}
