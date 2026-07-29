-- toggle diagnostics
local diagnostics_active = true
local function toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    print 'Diagnostics enabled'
  else
    vim.diagnostic.disable()
    print 'Diagnostics disabled'
  end
end

vim.api.nvim_create_user_command('ToggleDiagnostics', toggle_diagnostics, {})

-- Toggle diagnostics keymap
vim.keymap.set('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = 'Diagnostics Toggle', silent = true })
