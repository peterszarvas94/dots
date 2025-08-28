return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',

    -- 'L3MON4D3/LuaSnip',
    -- 'saadparwaiz1/cmp_luasnip',
    -- 'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require 'cmp'
    -- local luasnip = require 'luasnip'
    -- luasnip.config.setup {}
    -- require('luasnip.loaders.from_vscode').lazy_load()
    -- local lspkind = require 'lspkind'

    ---@diagnostic disable-next-line missing-fields
    cmp.setup {
      completion = {
        -- autocomplete = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- snippet = {
      --   expand = function(args)
      --     luasnip.lsp_expand(args.body)
      --   end,
      -- },
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
          -- option = {
          --   get_cwd = function()
          --     return vim.fn.getcwd()
          --   end,
          -- },
          keyword_pattern = [[\w\+/\?\w*]],
        },
        -- { name = 'buffer', priority = 3 },
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
        -- format = lspkind.cmp_format {
        --   mode = 'symbol_text',
        --   maxwidth = 200,
        --   ellipsis_char = '...',
        --   show_labelDetails = true,
        --   before = function(entry, vim_item)
        --     vim_item.menu = ({
        --       buffer = '[Buffer]',
        --       nvim_lsp = '[LSP]',
        --       path = '[Path]',
        --       -- luasnip = '[Snippet]',
        --       nvim_lua = '[Lua]',
        --       -- copilot = '[Copilot]',
        --     })[entry.source.name] or ('[' .. entry.source.name .. ']')
        --     return vim_item
        --   end,
        -- },
      },
    }
  end,
}
