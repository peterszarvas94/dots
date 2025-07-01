vim.api.nvim_create_user_command('BufOnly', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      local buf_modified = vim.api.nvim_buf_get_option(buf, 'modified')
      if not buf_modified then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end

  vim.notify 'Closed all other buffers'
end, { desc = 'Close all buffers except the current one' })
