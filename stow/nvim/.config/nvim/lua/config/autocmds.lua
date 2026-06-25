vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.o.wrap = true
  end,
})

local function maybe_start_treesitter(bufnr)
  local ft = vim.bo[bufnr].filetype
  local bt = vim.bo[bufnr].buftype
  if bt ~= '' then
    return
  end
  if ft == 'markdown' or ft == 'markdown_inline' or ft == 'bash' or ft == 'sh' then
    return
  end

  local ok, err = pcall(vim.treesitter.start, bufnr)
  if not ok then
    vim.b[bufnr].ts_start_error = tostring(err)
  else
    vim.b[bufnr].ts_start_error = nil
  end
end

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
  pattern = '*',
  callback = function(args)
    maybe_start_treesitter(args.buf)
  end,
})

pcall(vim.api.nvim_del_user_command, 'TSInfo')
vim.api.nvim_create_user_command('TSInfo', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  local active = vim.treesitter.highlighter.active[bufnr] ~= nil

  local lines = {
    ('bufnr: %d'):format(bufnr),
    ('filetype: %s'):format(ft ~= '' and ft or '(none)'),
    ('lang: %s'):format(lang or '(none)'),
    ('parser: %s'):format(ok and 'yes' or 'no'),
    ('highlight: %s'):format(active and 'active' or 'inactive'),
  }

  local q = vim.treesitter.query.get(lang, 'highlights')
  table.insert(lines, ('highlights_query: %s'):format(q and 'yes' or 'no'))

  local ok_inspect, inspect = pcall(vim.treesitter.language.inspect, lang)
  if ok_inspect and type(inspect) == 'table' and inspect.path then
    table.insert(lines, ('parser_path: %s'):format(inspect.path))
  end

  if ok and parser and parser.lang then
    table.insert(lines, ('parser_lang: %s'):format(parser:lang()))
  end

  if vim.b[bufnr].ts_start_error then
    table.insert(lines, ('start_error: %s'):format(vim.b[bufnr].ts_start_error))
  end

  vim.api.nvim_echo({ { table.concat(lines, '\n'), 'None' } }, false, {})
end, { desc = 'Show Tree-sitter status for current buffer' })

local yank_highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight_group,
  pattern = '*',
})

