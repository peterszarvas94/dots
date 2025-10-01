vim.filetype.add {
  extension = {
    templ = 'templ',
    astro = 'astro',
  },
  pattern = {
    ['.*%.html%.erb'] = 'eruby',
    ['.*%.erb'] = 'eruby',
  },
}

local M = {}

M.lsp_indent = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd 'normal! ggVG='
  vim.api.nvim_win_set_cursor(0, pos)
end

return M
