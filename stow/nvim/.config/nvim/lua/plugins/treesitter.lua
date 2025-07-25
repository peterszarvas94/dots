return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
  },
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'go',
        'javascript',
        'typescript',
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

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      modules = { 'go', 'lua', 'tsx', 'typescript' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
        },
      },
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
}
