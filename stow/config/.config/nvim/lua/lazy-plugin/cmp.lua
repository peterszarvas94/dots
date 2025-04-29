return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'onsails/lspkind.nvim',
    -- 'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}
    require('luasnip.loaders.from_vscode').lazy_load()
    local lspkind = require 'lspkind'

    ---@diagnostic disable-next-line missing-fields
    cmp.setup {
      completion = {
        -- autocomplete = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
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
        -- { name = 'copilot', priority = 2 },
        -- { name = 'luasnip', prioryty = 2 }
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text', -- show only symbol annotations
          maxwidth = 200, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(entry, vim_item)
            -- ...
            return vim_item
          end,
          -- symbol_map = { Copilot = '' },
        },
      },
    }
  end,
}
