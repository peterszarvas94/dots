return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      },
    },
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          file_ignore_patterns = { 'node_modules', '.git' },
          layout_strategy = 'vertical',
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

      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch [R]ecently opened files' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N] files' })
      vim.keymap.set('n', '<leader>sl', builtin.live_grep, { desc = '[S]earch by [L]ivegrep' })
      -- vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = '[S]earch [G]it' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch dia[G]nostics' })
      -- vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, { desc = '[S]earch [C]urrent buffer' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>si', builtin.highlights, { desc = '[S]earch H[i]ghlights' })
      vim.keymap.set('n', '<leader>sg', builtin.git_commits, { desc = '[S]earch [C]ommits' })
      vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, { desc = '[S]earch [B]uffer commits' })
      vim.keymap.set('n', '<leader>ss', builtin.git_stash, { desc = '[S]earch [S]tash' })
      vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
      -- vim.keymap.set('n', '<leader>sd', ':Telescope git_diffs diff_commits<CR>', { desc = '[S]earch [D]iffs' })
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

      vim.keymap.set('n', '<leader>i', function()
        require('actions-preview').code_actions()
      end, { desc = 'Code actions / [I]mports', silent = true })
    end,
  },
}
