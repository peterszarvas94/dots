-- set spaces as tabs
local function spaces()
  vim.cmd 'set tabstop=4 | set shiftwidth=4 | set expandtab'
  vim.cmd [[ %s/\t/  /ge | update ]]
end

vim.api.nvim_create_user_command('Spaces', spaces, {})

-- set tabs as tabs
local function tabs()
  vim.cmd 'set tabstop=4 | set shiftwidth=4 | set noexpandtab'
  vim.cmd [[ %s/  /\t/ge | update ]]
end

vim.api.nvim_create_user_command('Tabs', tabs, {})
