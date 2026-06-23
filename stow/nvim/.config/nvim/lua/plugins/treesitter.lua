return {
  {
    'neovim-treesitter/nvim-treesitter',
    branch = 'main',
    dependencies = {
      'neovim-treesitter/treesitter-parser-registry',
    },
    build = ':TSUpdate',
    lazy = false,
    config = function()
      local ts = require 'nvim-treesitter'

      ts.setup {}

      vim.o.rtp = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime,' .. vim.o.rtp

      ts.install {
        'bash',
        'css',
        'go',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'ruby',
        'rust',
        'sql',
        'templ',
        'toml',
        'tsx',
        'typescript',
        'yaml',
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      local tscontext = require 'treesitter-context'
      tscontext.setup {
        mode = 'topline',
        max_lines = 3,
        multiline_threshold = 20,
        separator = '-',
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
