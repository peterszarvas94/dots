return {
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
        -- layout_config = {
        --   vertical = {
        --     prompt_position = 'top',
        --   },
        --   mirror = true,
        -- },
        wrap_results = true
      },
      pickers = {
        live_grep = {
          additional_args = function(_)
            return { '--hidden' }
          end,
        },
        find_files = {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        },
      },
    }

    pcall(telescope.load_extension, 'fzf')


    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch [R]ecently opened files' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sl', builtin.live_grep, { desc = '[S]earch by [L]ivegrep' })
    vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = '[S]earch [G]it' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
    vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, { desc = '[S]earch [C]urrent buffer' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>si', builtin.highlights, { desc = '[S]earch H[i]ghlights' })
    vim.keymap.set('n', '<leader>sg', builtin.git_bcommits, { desc = '[S]earch [G]it commits' })
    vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
  end,
}