local keymaps = require 'config.keymaps'

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'norcalli/nvim-terminal.lua',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release && cmake --install build --prefix build',
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
      keymaps.setTelescopeKeymaps(builtin)

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
    end,
  },
}
