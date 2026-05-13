return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      local tscontext = require 'treesitter-context'
      tscontext.setup {
        enable = false,
      }
      vim.keymap.set('n', '<leader>cx', function()
        tscontext.toggle()
      end, { desc = 'TSContext toggle', silent = true })
    end,
  },
  {
    'joerdav/templ.vim',
    ft = 'templ',
  },
}
