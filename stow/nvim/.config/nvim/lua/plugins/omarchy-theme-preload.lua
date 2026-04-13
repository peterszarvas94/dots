local uv = vim.uv or vim.loop
local is_macos = uv and uv.os_uname and uv.os_uname().sysname == 'Darwin'

if is_macos then
  return {}
end

return {
  {
    name = 'theme-hotreload',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
      local timer_id = nil
      local last_hash = nil

      local function theme_hash()
        if vim.fn.filereadable(theme_file) ~= 1 then
          return nil
        end

        local content = table.concat(vim.fn.readfile(theme_file), '\n')
        return vim.fn.sha256(content)
      end

      local function load_theme_spec()
        local ok, theme_spec = pcall(dofile, theme_file)
        if not ok or type(theme_spec) ~= 'table' then
          return nil
        end

        return theme_spec
      end

      local function desired_from_spec(theme_spec)
        for _, spec in ipairs(theme_spec) do
          if spec[1] == 'LazyVim/LazyVim' and spec.opts and spec.opts.colorscheme then
            local colorscheme = spec.opts.colorscheme

            local lower = colorscheme:lower()
            if lower == 'rose-pine' then
              return colorscheme, 'dark'
            elseif lower:match 'dawn' or lower:match 'light' or lower:match 'latte' then
              return colorscheme, 'light'
            elseif lower:match 'dark' or lower:match 'night' or lower:match 'moon' then
              return colorscheme, 'dark'
            end

            return colorscheme, vim.o.background
          end
        end

        return nil, nil
      end

      local function reload_theme(force)
        local current_hash = theme_hash()
        if not current_hash then
          return nil, false
        end

        if not force and current_hash == last_hash then
          return nil, false
        end

        local theme_spec = load_theme_spec()
        if not theme_spec then
          return nil, false
        end

        local colorscheme, target_background = desired_from_spec(theme_spec)
        if not colorscheme then
          return nil, false
        end

        local apply_colorscheme = colorscheme
        if colorscheme:match '^rose%-pine' then
          local variant = target_background == 'light' and 'dawn' or 'main'
          local ok_rose_pine, rose_pine = pcall(require, 'rose-pine')
          if ok_rose_pine and rose_pine and rose_pine.setup then
            pcall(rose_pine.setup, {
              variant = variant,
              dark_variant = 'main',
              styles = {
                italic = false,
                bold = false,
              },
            })
          end
          apply_colorscheme = 'rose-pine'
        end

        vim.o.background = target_background

        local ok_loader, loader = pcall(require, 'lazy.core.loader')
        if ok_loader and loader and loader.colorscheme then
          pcall(loader.colorscheme, apply_colorscheme)
        end

        vim.defer_fn(function()
          pcall(vim.cmd.colorscheme, apply_colorscheme)
          vim.o.background = target_background
          if colorscheme == 'gruvbox' then
            pcall(vim.cmd.set, 'background=dark')
          end
        end, 5)

        last_hash = current_hash
        return colorscheme, true
      end

      pcall(vim.api.nvim_del_user_command, 'SyncTheme')
      vim.api.nvim_create_user_command('SyncTheme', function(opts)
        local colorscheme, changed = reload_theme(opts.bang)
        local status = changed and 'updated' or 'already in sync'
        vim.notify(('Theme sync: %s (%s)'):format(colorscheme or 'unknown', status), vim.log.levels.INFO)
      end, {
        bang = true,
        desc = 'Reload Neovim theme from Omarchy theme file',
      })

      local group = vim.api.nvim_create_augroup('OmarchyThemeHotReload', { clear = true })

      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'LazyReload',
        callback = function()
          reload_theme(true)
        end,
      })

      vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume' }, {
        group = group,
        callback = function()
          reload_theme(true)
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
        group = group,
        callback = function()
          reload_theme(true)
        end,
      })

      timer_id = vim.fn.timer_start(1500, function()
        vim.schedule(function()
          if vim.v.exiting == 0 then
            reload_theme(true)
          end
        end)
      end, { ['repeat'] = -1 })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = group,
        callback = function()
          if timer_id then
            pcall(vim.fn.timer_stop, timer_id)
            timer_id = nil
          end
        end,
      })

      reload_theme(true)
    end,
  },
}
