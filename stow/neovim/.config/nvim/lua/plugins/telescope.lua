return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim', -- emojis
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release && cmake --install build --prefix build',
      },
    },
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          border = true,
          file_ignore_patterns = { 'node_modules', '.git', '.*_templ%.go$' },
          layout_strategy = 'horizontal',
          wrap_results = true,
        },
        pickers = {
          live_grep = {
            additional_args = function(_)
              return { '--hidden' }
            end,
          },
          find_files = {
            hidden = true,
            no_ignore = false,
            no_ignore_parent = false,
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      local builtin = require 'telescope.builtin'

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = 'Search Recently opened files' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search Files' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files {
          cwd = vim.fn.stdpath 'config',
        }
      end, { desc = 'Search Nvim files' })

      vim.keymap.set('n', '<leader>sd', function()
        builtin.find_files {
          cwd = vim.fn.expand '~' .. '/projects/dots/',
        }
      end, { desc = 'Search Dotfiles' })

      vim.keymap.set('n', '<leader>sl', builtin.live_grep, { desc = 'Search by Livegrep' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current Word' })
      vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, { desc = 'Search Current buffer' })
      vim.keymap.set('n', '<leader>so', function()
        local word = vim.fn.expand '<cword>'
        builtin.current_buffer_fuzzy_find { default_text = word }
      end, { silent = true, desc = 'Search wOrd in current buffer' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
      vim.keymap.set('n', '<leader>sg', builtin.git_commits, { desc = 'Search Commits' })
      vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, { desc = 'Search Buffer commits' })
      vim.keymap.set('n', '<leader>ss', builtin.git_stash, { desc = 'Search Stash' })
      vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = 'Search Emojis' })
      vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Search Marks' })
      vim.keymap.set('n', '<leader>su', builtin.buffers, { desc = 'Search bUffers' })
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Lsp References' })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopeFindPre',
        callback = function()
          vim.opt_local.winborder = 'none'
          vim.api.nvim_create_autocmd('WinLeave', {
            once = true,
            callback = function()
              vim.opt_local.winborder = 'rounded'
            end,
          })
        end,
      })
    end,
  },
  {
    'aznhe21/actions-preview.nvim',
    config = function()
      require('actions-preview').setup {
        telescope = {
          sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = 'top',
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      }

      -- Code actions keymap
      vim.keymap.set('n', '<leader>i', function()
        require('actions-preview').code_actions()
      end, { desc = 'Code actions / Imports', silent = true })
    end,
  },
}
