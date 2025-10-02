-- Line number commands (moved from autocmds.lua)

vim.api.nvim_create_user_command('RelativeNumbersOn', function()
  vim.cmd 'windo if &buftype != "terminal" | set relativenumber | endif'
  vim.g.relative_numbers_enabled = true
  print 'Relative line numbers enabled in all non-terminal windows'
end, { desc = 'Enable relative line numbers in all windows' })

vim.api.nvim_create_user_command('RelativeNumbersOff', function()
  vim.cmd 'windo if &buftype != "terminal" | set norelativenumber | endif'
  vim.g.relative_numbers_enabled = false
  print 'Relative line numbers disabled in all non-terminal windows'
end, { desc = 'Disable relative line numbers in all windows' })

vim.api.nvim_create_user_command('RelativeNumbersToggle', function()
  -- Initialize global variable if it doesn't exist
  if vim.g.relative_numbers_enabled == nil then
    vim.g.relative_numbers_enabled = vim.wo.relativenumber
  end

  -- Toggle the global state
  vim.g.relative_numbers_enabled = not vim.g.relative_numbers_enabled

  -- Apply the state to all non-terminal windows
  if vim.g.relative_numbers_enabled then
    vim.cmd 'windo if &buftype != "terminal" | set relativenumber | endif'
    print 'Relative line numbers enabled in all non-terminal windows'
  else
    vim.cmd 'windo if &buftype != "terminal" | set norelativenumber | endif'
    print 'Relative line numbers disabled in all non-terminal windows'
  end
end, { desc = 'Toggle relative line numbers in all windows' })

-- Relative line numbers keymaps
vim.keymap.set('n', '<leader>ro', ':RelativeNumbersOn<CR>', { desc = 'Relative numbers On', silent = true })
vim.keymap.set('n', '<leader>rf', ':RelativeNumbersOff<CR>', { desc = 'Relative numbers oFf', silent = true })
vim.keymap.set('n', '<leader>rt', ':RelativeNumbersToggle<CR>', { desc = 'Relative numbers Toggle', silent = true })