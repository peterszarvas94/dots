-- relative line numbers on
vim.api.nvim_create_user_command('RelOn', function()
  vim.o.relativenumber = true
end, {})

-- relative line numbers on
vim.api.nvim_create_user_command('RelOff', function()
  vim.o.relativenumber = false
end, {})
