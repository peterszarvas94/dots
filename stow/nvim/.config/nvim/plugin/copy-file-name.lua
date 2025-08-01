vim.api.nvim_create_user_command('CopyFileName', function()
  local filename = vim.fn.expand '%:t'
  vim.fn.setreg('+', filename)
  vim.notify('Copied filename: ' .. filename)
end, {})

vim.api.nvim_create_user_command('CopyFileNameNoExt', function()
  local filename = vim.fn.expand '%:t:r'
  vim.fn.setreg('+', filename)
  vim.notify('Copied filename without extension: ' .. filename)
end, {})

vim.api.nvim_create_user_command('CopyFilePath', function()
  local file_dir = vim.fn.expand '%:p:h'

  local git_root_cmd = 'git -C ' .. vim.fn.shellescape(file_dir) .. ' rev-parse --show-toplevel 2>/dev/null'
  local git_root = vim.fn.trim(vim.fn.system(git_root_cmd))

  local filepath
  if git_root ~= '' then
    local full_path = vim.fn.expand '%:p'

    if vim.startswith(full_path, git_root) then
      filepath = full_path:sub(#git_root + 2)
    else
      filepath = vim.fn.expand '%'
    end
  else
    filepath = vim.fn.expand '%'
  end

  vim.fn.setreg('+', filepath)
  vim.notify('Copied file path: ' .. filepath)
end, {})
