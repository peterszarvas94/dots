return {
  -- omarchy theme hot preloads
  {
    'bjarneo/ethereal.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'ribru17/bamboo.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = true,
  },
  {
    'neanias/everforest-nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'kepano/flexoki-neovim',
    priority = 1000,
    lazy = true,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'tahayvr/matteblack.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'loctvl842/monokai-pro.nvim',
    priority = 1000,
    lazy = true,
    config = function()
      require('monokai-pro').setup {
        filter = 'ristretto',
        override = function()
          return {
            NonText = { fg = '#948a8b' },
            MiniIconsGrey = { fg = '#948a8b' },
            MiniIconsRed = { fg = '#fd6883' },
            MiniIconsBlue = { fg = '#85dacc' },
            MiniIconsGreen = { fg = '#adda78' },
            MiniIconsYellow = { fg = '#f9cc6c' },
            MiniIconsOrange = { fg = '#f38d70' },
            MiniIconsPurple = { fg = '#a8a9eb' },
            MiniIconsAzure = { fg = '#a8a9eb' },
            MiniIconsCyan = { fg = '#85dacc' },
          }
        end,
      }
    end,
  },
  {
    'shaunsingh/nord.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = true,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = true,
  },
  {
    'steve-lohmeyer/mars.nvim',
    name = 'mars',
    priority = 1000,
    lazy = true,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    -- Customize theme specs, e.g: disable italic. For full spec: https://github.com/rose-pine/neovim
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
    -- for the fake lazyvim integration in omarchy
    'LazyVim/LazyVim',
    opts = {},
  },

  -- omarchy theme hot reloading
  {
    name = 'theme-hotreload',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyReload',
        callback = function()
          package.loaded['plugins.theme'] = nil

          vim.schedule(function()
            local ok, theme_spec = pcall(require, 'plugins.theme')
            if not ok then
              return
            end

            for _, spec in ipairs(theme_spec) do
              if spec[1] == 'LazyVim/LazyVim' and spec.opts and spec.opts.colorscheme then
                local colorscheme = spec.opts.colorscheme

                require('lazy.core.loader').colorscheme(colorscheme)

                vim.defer_fn(function()
                  pcall(vim.cmd.colorscheme, colorscheme)
                  -- set bg to dark for gruvbox
                  if colorscheme == 'gruvbox' then
                    pcall(vim.cmd.set, 'background=dark')
                  end
                end, 5)

                break
              end
            end
          end)
        end,
      })
    end,
  },
}
