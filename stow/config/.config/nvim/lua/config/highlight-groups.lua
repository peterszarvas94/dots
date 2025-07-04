-- Set Normal and NormalNC to use transparent background with default colors
vim.api.nvim_set_hl(0, 'Normal', { ctermfg = 'none', fg = '#C4C6CD', bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { ctermfg = 'none', fg = '#C4C6CD', bg = 'none' })

-- Set NvimTreeNormal to have transparent background with default colors
vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })

-- Set NvimTreeWinSeparator to have custom separator color
vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { fg = '#1e1e2e', bg = 'none' })

-- Set TreesitterContext to have no background
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#1e1e2e' })

vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#1e1e2e', fg = '#f9e2af' })

vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { bg = 'none', fg = 'none' })

-- vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#A6DBFF' }) -- NvimLightBlue

-- Set LineNr to use the NvimDarkGrey3 color for line numbers
-- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#C4C6CD' })

-- Set WinSeparator to have the NvimDarkGrey3 separator color
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#1e1e2e', bg = 'none' })

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
