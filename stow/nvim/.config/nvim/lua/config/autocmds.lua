vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.o.wrap = true
  end,
})

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
