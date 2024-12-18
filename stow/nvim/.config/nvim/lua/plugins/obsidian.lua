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
      folder = '.daily',
    },
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_forma = 'H:%M',
    },
    disable_frontmatter = true,
    ui = { enable = false },
    attachments = {
      img_folder = 'images',
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    -- disable_formatter = function()
    --   if vim.loop.cwd() == vim.fn.expand '~/obsidian-remote' then
    --     return true
    --   else
    --     return false
    --   end
    -- end,
  },
}
