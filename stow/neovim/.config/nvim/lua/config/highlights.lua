-- Transparent floating window configurations
local function set_transparent_highlights()
  -- Make all floating windows transparent
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })

  -- Telescope floating windows
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = 'NONE' })

  -- Which-key floating windows
  vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'NONE' })

  -- LSP floating windows
  vim.api.nvim_set_hl(0, 'LspInfoBorder', { bg = 'NONE' })

  -- Completion menu
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'PmenuBorder', { bg = 'NONE' })

  -- Notify floating windows
  vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = 'NONE' })

  -- Lazy.nvim floating windows
  vim.api.nvim_set_hl(0, 'LazyNormal', { bg = 'NONE' })

  -- Mason floating windows
  vim.api.nvim_set_hl(0, 'MasonNormal', { bg = 'NONE' })
end

-- Apply highlights immediately
set_transparent_highlights()

-- Create an autocmd to reapply highlights when colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_transparent_highlights,
  group = vim.api.nvim_create_augroup('TransparentFloats', { clear = true })
})