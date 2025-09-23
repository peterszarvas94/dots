return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local cmp = require 'cmp'

    ---@diagnostic disable-next-line missing-fields
    cmp.setup {
      completion = {
        -- autocomplete = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item {
          behavior = cmp.SelectBehavior.Select,
        },
        ['<C-p>'] = cmp.mapping.select_prev_item {
          behavior = cmp.SelectBehavior.Select,
        },
        ['<C-d>'] = cmp.mapping.select_next_item {
          behavior = cmp.SelectBehavior.Select,
          count = 10,
        },
        ['<C-u>'] = cmp.mapping.select_prev_item {
          behavior = cmp.SelectBehavior.Select,
          count = 10,
        },
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-a>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior,
          select = true,
        },
      },
      sources = {
        { name = 'nvim_lsp', priority = 1 },
        {
          name = 'path',
          priority = 2,
          keyword_pattern = [[\w\+/\?\w*]],
        },
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
