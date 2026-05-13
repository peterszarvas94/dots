return {
  {
    name = 'theme-hotreload',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
      local server_registry = vim.fn.stdpath 'state' .. '/theme-sync-servers'

      local function read_theme_data()
        local ok, data = pcall(dofile, theme_file)
        if not ok or type(data) ~= 'table' then
          return nil
        end

        if type(data.colorscheme) == 'string' and data.colorscheme ~= '' then
          return {
            colorscheme = data.colorscheme,
            background = data.background == 'light' and 'light' or 'dark',
          }
        end

        for _, spec in ipairs(data) do
          if spec[1] == 'LazyVim/LazyVim' and type(spec.opts) == 'table' then
            local cs = spec.opts.colorscheme
            if type(cs) == 'string' and cs ~= '' then
              return {
                colorscheme = cs,
                background = spec.opts.background == 'light' and 'light' or 'dark',
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

        vim.o.background = theme.background
        pcall(vim.cmd.colorscheme, theme.colorscheme)
        return theme.colorscheme, true
      end

      local function register_server()
        local server = vim.v.servername
        if not server or server == '' then
          local run_dir = vim.fn.stdpath 'run'
          vim.fn.mkdir(run_dir, 'p')
          local socket = run_dir .. '/theme-sync-' .. vim.fn.getpid() .. '.sock'
          pcall(vim.fn.serverstart, socket)
          server = vim.v.servername
        end

        if not server or server == '' then
          return
        end

        local lines = {}
        if vim.fn.filereadable(server_registry) == 1 then
          local ok, existing = pcall(vim.fn.readfile, server_registry)
          if ok and type(existing) == 'table' then
            lines = existing
          end
        end

        local seen = {}
        local out = {}
        for _, line in ipairs(lines) do
          if line ~= '' and not seen[line] then
            seen[line] = true
            table.insert(out, line)
          end
        end
        if not seen[server] then
          table.insert(out, server)
        end
        pcall(vim.fn.writefile, out, server_registry)
      end

      pcall(vim.api.nvim_del_user_command, 'SyncTheme')
      vim.api.nvim_create_user_command('SyncTheme', function()
        local colorscheme, changed = sync_theme()
        local status = changed and 'updated' or 'failed'
        vim.notify(('Theme sync: %s (%s)'):format(colorscheme or 'unknown', status), vim.log.levels.INFO)
      end, {
        bang = true,
        desc = 'Reload Neovim theme from Omarchy theme file',
      })

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          register_server()
          sync_theme()
        end,
      })

      register_server()
      sync_theme()
    end,
  },
}
