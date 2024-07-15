return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = 'markdown',
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/obsidian-remote/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/obsidian-remote/**.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'obsidian-remote',
        path = '~/obsidian-remote',
      },
    },
    daily_notes = {
      folder = '0 - daily',
      date_format = '%Y/%m/%Y-%m-%d',
      template = 'daily.md',
    },
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = 'H:%M',
    },
    disable_frontmatter = true,
    ui = { enable = false },
    -- disable_formatter = function()
    --   if vim.loop.cwd() == vim.fn.expand '~/obsidian-remote' then
    --     return true
    --   else
    --     return false
    --   end
    -- end,
  },
}
