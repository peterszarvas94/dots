local uv = vim.uv or vim.loop

local runtime_state = _G.__theme_runtime_state or { instances = {} }
_G.__theme_runtime_state = runtime_state

local function normalize_theme(data, fallback)
  if type(data) ~= 'table' then
    return fallback
  end

  if type(data.colorscheme) == 'string' or data.background == 'dark' or data.background == 'light' then
    local background = data.background == 'light' and 'light' or 'dark'
    local colorscheme = type(data.colorscheme) == 'string' and data.colorscheme or fallback.colorscheme
    return {
      background = background,
      colorscheme = colorscheme,
    }
  end

  for _, spec in ipairs(data) do
    if spec[1] == 'LazyVim/LazyVim' and spec.opts and type(spec.opts.colorscheme) == 'string' then
      return {
        background = fallback.background,
        colorscheme = spec.opts.colorscheme,
      }
    end
  end

  return fallback
end

local function read_theme(theme_file, fallback)
  local ok, data = pcall(dofile, theme_file)
  if not ok then
    return fallback
  end

  return normalize_theme(data, fallback)
end

local function apply_theme(theme)
  vim.o.background = theme.background

  local ok_loader, loader = pcall(require, 'lazy.core.loader')
  if ok_loader and loader and loader.colorscheme then
    pcall(loader.colorscheme, theme.colorscheme)
  end

  pcall(vim.cmd.colorscheme, theme.colorscheme)
end

local function sync_theme(name, force)
  local instance = runtime_state.instances[name]
  if not instance then
    return nil, false
  end

  local theme = read_theme(instance.theme_file, instance.fallback)
  if instance.lock_colorscheme then
    theme.colorscheme = instance.lock_colorscheme
  end

  local changed = force
    or instance.background ~= theme.background
    or instance.colorscheme ~= theme.colorscheme

  if not changed then
    return theme, false
  end

  instance.background = theme.background
  instance.colorscheme = theme.colorscheme
  apply_theme(theme)

  return theme, true
end

local function setup_runtime(opts)
  local name = opts.name or 'default'
  local fallback = opts.fallback or {
    background = 'dark',
    colorscheme = 'rose-pine',
  }

  local instance = runtime_state.instances[name] or {}
  instance.theme_file = opts.theme_file or vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
  instance.theme_dir = vim.fn.fnamemodify(instance.theme_file, ':h')
  instance.theme_name = vim.fn.fnamemodify(instance.theme_file, ':t')
  instance.fallback = fallback
  instance.lock_colorscheme = opts.lock_colorscheme
  runtime_state.instances[name] = instance

  pcall(vim.api.nvim_del_user_command, 'SyncTheme')
  vim.api.nvim_create_user_command('SyncTheme', function(cmd_opts)
    local theme, changed = sync_theme(name, cmd_opts.bang)
    local status = changed and 'updated' or 'already in sync'
    vim.notify(('Theme sync: %s/%s (%s)'):format(theme.colorscheme, theme.background, status), vim.log.levels.INFO)
  end, {
    bang = true,
    desc = 'Reload Neovim theme from generated theme file',
  })

  local group_name = opts.group_name or ('ThemeRuntimeSync_' .. name)
  vim.api.nvim_create_autocmd(opts.events or { 'VimEnter', 'FocusGained', 'VimResume' }, {
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
    callback = function()
      sync_theme(name, false)
    end,
  })

  if opts.user_pattern then
    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup(group_name .. '_User', { clear = true }),
      pattern = opts.user_pattern,
      callback = function()
        sync_theme(name, false)
      end,
    })
  end

  if opts.watch_file and uv and uv.new_fs_event then
    if instance.watcher and not instance.watcher:is_closing() then
      instance.watcher:stop()
      instance.watcher:close()
      instance.watcher = nil
    end

    local watcher = uv.new_fs_event()
    local ok = watcher:start(instance.theme_dir, {}, vim.schedule_wrap(function(err, fname)
      if err then
        return
      end
      if fname and fname ~= instance.theme_name then
        return
      end
      if vim.v.exiting == 0 then
        sync_theme(name, false)
      end
    end))

    if ok then
      instance.watcher = watcher
      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup(group_name .. '_Cleanup', { clear = true }),
        callback = function()
          if instance.watcher and not instance.watcher:is_closing() then
            instance.watcher:stop()
            instance.watcher:close()
            instance.watcher = nil
          end
        end,
      })
    elseif watcher and not watcher:is_closing() then
      watcher:close()
    end
  end

  sync_theme(name, true)
end

local function running_on_macos()
  return uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'
end

local function runtime_spec(name, events, user_pattern)
  return {
    name = 'theme-runtime',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      setup_runtime {
        name = name,
        theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua',
        fallback = {
          background = 'dark',
          colorscheme = 'rose-pine',
        },
        lock_colorscheme = 'rose-pine',
        watch_file = true,
        events = events,
        user_pattern = user_pattern,
        command_name = 'SyncTheme',
        command_desc = 'Reload Neovim theme from generated theme file',
      }
    end,
  }
end

local function fallback_rose_pine(platform_name)
  return {
    {
      'rose-pine/neovim',
      name = 'rose-pine',
      config = function()
        require('rose-pine').setup {
          styles = {
            italic = false,
            bold = false,
          },
        }
      end,
      priority = 1000,
      lazy = true,
    },
    {
      'LazyVim/LazyVim',
      opts = {
        colorscheme = 'rose-pine',
      },
    },
    runtime_spec(platform_name, { 'VimEnter', 'FocusGained', 'VimResume', 'BufEnter' }),
  }
end

if running_on_macos() then
  return fallback_rose_pine 'mac'
end

return fallback_rose_pine 'omarchy'
