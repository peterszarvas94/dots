return {
  {
    name = 'theme-hotreload',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
      local server_registry = vim.fn.stdpath 'state' .. '/theme-sync-servers'
      local last_hash = nil

      local function read_lines(path)
        if vim.fn.filereadable(path) ~= 1 then
          return {}
        end

        local ok, lines = pcall(vim.fn.readfile, path)
        if not ok or type(lines) ~= 'table' then
          return {}
        end

        return lines
      end

      local function write_lines(path, lines)
        pcall(vim.fn.writefile, lines, path)
      end

      local function unique_lines(lines)
        local seen = {}
        local out = {}

        for _, line in ipairs(lines) do
          if line ~= '' and not seen[line] then
            seen[line] = true
            table.insert(out, line)
          end
        end

        return out
      end

      local function ensure_server_name()
        local server = vim.v.servername
        if server and server ~= '' then
          return server
        end

        local run_dir = vim.fn.stdpath 'run'
        vim.fn.mkdir(run_dir, 'p')
        local socket = run_dir .. '/theme-sync-' .. vim.fn.getpid() .. '.sock'
        pcall(vim.fn.serverstart, socket)
        server = vim.v.servername

        if server and server ~= '' then
          return server
        end

        return nil
      end

      local function register_theme_server()
        local server = ensure_server_name()
        if not server then
          return
        end

        local lines = read_lines(server_registry)
        local found = false
        for _, line in ipairs(lines) do
          if line == server then
            found = true
            break
          end
        end

        if not found then
          table.insert(lines, server)
        end

        write_lines(server_registry, unique_lines(lines))
      end

      local function unregister_theme_server()
        local server = vim.v.servername
        if not server or server == '' then
          return
        end

        local lines = read_lines(server_registry)
        local keep = {}
        for _, line in ipairs(lines) do
          if line ~= server then
            table.insert(keep, line)
          end
        end

        write_lines(server_registry, unique_lines(keep))
      end

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

      local function apply_theme(colorscheme, target_background)
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

        apply_theme(colorscheme, target_background)

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
          reload_theme(false)
        end,
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = group,
        callback = function()
          unregister_theme_server()
        end,
      })

      register_theme_server()
      reload_theme(true)
    end,
  },
}
