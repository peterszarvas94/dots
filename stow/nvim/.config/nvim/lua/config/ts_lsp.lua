local M = {}

--- Run TypeScript LSP organize-imports when `tsc` is attached to the buffer.
function M.organize_imports(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if #vim.lsp.get_clients { bufnr = bufnr, name = 'tsc' } == 0 then
    return
  end
  vim.lsp.buf.code_action {
    bufnr = bufnr,
    context = { only = { 'source.organizeImports' } },
    apply = true,
  }
end

return M
