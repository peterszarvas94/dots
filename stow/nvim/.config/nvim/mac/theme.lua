return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
    local server_registry = vim.fn.stdpath("state") .. "/theme-sync-servers"

    local function read_theme()
      local ok, data = pcall(dofile, theme_file)
      local background = ok and type(data) == "table" and data.background == "light" and "light" or "dark"
      return {
        background = background,
        colorscheme = background == "light" and "rose-pine-dawn" or "rose-pine-moon",
      }
    end

    local function sync_theme()
      local theme = read_theme()
      vim.o.background = theme.background
      pcall(vim.cmd.colorscheme, theme.colorscheme)
      return theme
    end

    local function register_server()
      local server = vim.v.servername
      if not server or server == "" then
        local run_dir = vim.fn.stdpath("run")
        vim.fn.mkdir(run_dir, "p")
        pcall(vim.fn.serverstart, run_dir .. "/theme-sync-" .. vim.fn.getpid() .. ".sock")
        server = vim.v.servername
      end
      if not server or server == "" then
        return
      end

      vim.fn.mkdir(vim.fn.stdpath("state"), "p")
      local servers = vim.fn.filereadable(server_registry) == 1 and vim.fn.readfile(server_registry) or {}
      for _, existing in ipairs(servers) do
        if existing == server then
          return
        end
      end
      table.insert(servers, server)
      vim.fn.writefile(servers, server_registry)
    end

    require("rose-pine").setup({
      dark_variant = "moon",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = false,
        italic = false,
        transparency = false,
      },
    })

    sync_theme()
    register_server()

    pcall(vim.api.nvim_del_user_command, "SyncTheme")
    vim.api.nvim_create_user_command("SyncTheme", function()
      local theme = sync_theme()
      vim.notify(("Theme sync: %s/%s"):format(theme.colorscheme, theme.background), vim.log.levels.INFO)
    end, {
      bang = true,
      desc = "Sync Neovim theme from macOS appearance",
    })
  end,
}
