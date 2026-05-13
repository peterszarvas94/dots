return {
  {
    'folke/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'go',
          'javascript',
          'typescript',
          'templ',
          'html',
          'css',
          'json',
          'yaml',
          'lua',
          'rust',
          'toml',
          'markdown',
          'jsdoc',
          'bash',
          'ruby',
        },
        auto_install = true,
        highlight = {
          enable = true,
          disable = { 'markdown', 'markdown_inline', 'bash' },
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = false },
      }

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      ---@diagnostic disable-next-line
      parser_config.templ = {
        install_info = {
          url = 'https://github.com/vrischmann/tree-sitter-templ',
          files = { 'src/parser.c', 'src/scanner.c' },
        },
        filetype = 'templ',
      }
    end,
  },
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
