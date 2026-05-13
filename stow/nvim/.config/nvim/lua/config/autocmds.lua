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

local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'

local function infer_background(colorscheme, explicit)
  if explicit == 'light' or explicit == 'dark' then
    return explicit
  end

  if type(colorscheme) ~= 'string' then
    return 'dark'
  end

  local cs = colorscheme:lower()
  if cs:find('light', 1, true) or cs:find('day', 1, true) or cs:find('dawn', 1, true) then
    return 'light'
  end

  return 'dark'
end

local function read_theme_data()
  local ok, data = pcall(dofile, theme_file)
  if not ok or type(data) ~= 'table' then
    return nil
  end

  if type(data.colorscheme) == 'string' and data.colorscheme ~= '' then
    return {
      colorscheme = data.colorscheme,
      background = infer_background(data.colorscheme, data.background),
    }
  end

  for _, spec in ipairs(data) do
    if spec[1] == 'LazyVim/LazyVim' and type(spec.opts) == 'table' then
      local cs = spec.opts.colorscheme
      if type(cs) == 'string' and cs ~= '' then
        return {
          colorscheme = cs,
          background = infer_background(cs, spec.opts.background),
        }
      end
    end
  end

  return nil
end

local function sync_theme()
  local theme = read_theme_data()
  if not theme then
    return nil, false
  end

  if theme.colorscheme == 'rose-pine' then
    if theme.background == 'light' then
      theme.colorscheme = 'rose-pine-dawn'
    else
      theme.colorscheme = 'rose-pine-main'
    end
  elseif theme.colorscheme == 'rose-pine-dawn' and theme.background == 'dark' then
    theme.colorscheme = 'rose-pine-main'
  elseif (theme.colorscheme == 'rose-pine-main' or theme.colorscheme == 'rose-pine-moon') and theme.background == 'light' then
    theme.colorscheme = 'rose-pine-dawn'
  end

  vim.o.background = theme.background
  pcall(vim.cmd.colorscheme, theme.colorscheme)
  return theme.colorscheme, true
end

pcall(vim.api.nvim_del_user_command, 'SyncTheme')
vim.api.nvim_create_user_command('SyncTheme', function()
  local colorscheme, changed = sync_theme()
  if changed then
    vim.api.nvim_echo({ { ('Theme is synced: %s (%s)'):format(colorscheme or 'unknown', vim.o.background), 'None' } }, false, {})
  else
    vim.api.nvim_echo({ { 'Theme sync failed', 'WarningMsg' } }, false, {})
  end
end, {
  bang = true,
  desc = 'Reload Neovim theme from Omarchy theme file',
})
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('OmarchyThemeSync', { clear = true }),
  callback = function()
    sync_theme()
  end,
})
