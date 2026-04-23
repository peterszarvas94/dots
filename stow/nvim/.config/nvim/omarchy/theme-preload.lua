return {
  {
    name = 'theme-hotreload',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
      local server_registry = vim.fn.stdpath 'state' .. '/theme-sync-servers'

      local function dedupe(lines)
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

      local function current_or_started_server()
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

      local function update_server_registry(remove_current)
        local server = vim.v.servername
        if not remove_current then
          server = current_or_started_server()
        end

        if not server then
          return
        end

        local lines = {}
        if vim.fn.filereadable(server_registry) == 1 then
          local ok, existing = pcall(vim.fn.readfile, server_registry)
          if ok and type(existing) == 'table' then
            lines = existing
          end
        end

        local keep = {}
        local found = false
        for _, line in ipairs(lines) do
          if line == server then
            found = true
          elseif line ~= '' then
            table.insert(keep, line)
          end
        end

        if not remove_current then
          table.insert(keep, server)
        elseif not found then
          return
        end

        pcall(vim.fn.writefile, dedupe(keep), server_registry)
      end

      local function read_theme()
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

        for _, entry in ipairs(data) do
          if type(entry) == 'table' and entry[1] == 'LazyVim/LazyVim' and type(entry.opts) == 'table' then
            local colorscheme = entry.opts.colorscheme
            if type(colorscheme) == 'string' and colorscheme ~= '' then
              return {
                colorscheme = colorscheme,
                background = entry.opts.background == 'light' and 'light' or 'dark',
              }
            end
          end
        end

        return nil
      end

      local function sync_theme()
        local theme = read_theme()
        if not theme then
          return nil, false
        end

        vim.o.background = theme.background
        pcall(vim.cmd.colorscheme, theme.colorscheme)
        return theme.colorscheme, true
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

      local group = vim.api.nvim_create_augroup('OmarchyThemeHotReload', { clear = true })

      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'LazyReload',
        callback = function()
          sync_theme()
        end,
      })

      vim.api.nvim_create_autocmd('VimEnter', {
        group = group,
        callback = function()
          sync_theme()
        end,
      })

      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = group,
        callback = function()
          update_server_registry(true)
        end,
      })

      update_server_registry(false)
      sync_theme()
    end,
  },
}
