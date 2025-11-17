return {
  {
    "ribru17/bamboo.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
  },
  {
    "neanias/everforest-nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "kepano/flexoki-neovim",
    priority = 1000,
    lazy = true,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "tahayvr/matteblack.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      require("monokai-pro").setup({
        filter = "ristretto",
        override = function()
          return {
            NonText = { fg = "#948a8b" },
            MiniIconsGrey = { fg = "#948a8b" },
            MiniIconsRed = { fg = "#fd6883" },
            MiniIconsBlue = { fg = "#85dacc" },
            MiniIconsGreen = { fg = "#adda78" },
            MiniIconsYellow = { fg = "#f9cc6c" },
            MiniIconsOrange = { fg = "#f38d70" },
            MiniIconsPurple = { fg = "#a8a9eb" },
            MiniIconsAzure = { fg = "#a8a9eb" },
            MiniIconsCyan = { fg = "#85dacc" },
          }
        end,
      })
    end,
  },
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    lazy = true,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = true,
  },
  {
    -- for the fake lazyvim integration in omarchy
    -- can we remove this for mac maybe?
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'catppuccin',
    },
  },
}
