-- find and replace in quickfix list
local function find_and_replace_in_quickfix()
  local find = vim.fn.input 'Find: '
  if find == '' then
    print 'Find can not be empty'
    return
  end

  local replace = vim.fn.input 'Replace: '

  vim.cmd(string.format('cdo %%s/%s/%s/gc', vim.fn.escape(find, '/'), vim.fn.escape(replace, '/')))
end

vim.api.nvim_create_user_command('FindAndReplaceInQuickfix', find_and_replace_in_quickfix, {})
