local theme_plugins = {
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'folke/tokyonight.nvim' },
  { 'neanias/everforest-nvim' },
  { 'kepano/flexoki-neovim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'bjarneo/ethereal.nvim' },
  { 'bjarneo/hackerman.nvim', dependencies = { 'bjarneo/aether.nvim' } },
  { 'rebelot/kanagawa.nvim' },
  { 'omacom-io/lumon.nvim' },
  { 'tahayvr/matteblack.nvim' },
  { 'OldJobobo/miasma.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'ribru17/bamboo.nvim' },
  { 'OldJobobo/retro-82.nvim' },
  { 'gthelding/monokai-pro.nvim' },
  { 'bjarneo/vantablack.nvim' },
  { 'bjarneo/white.nvim' },
  { 'steve-lohmeyer/mars.nvim' },
  { 'bjarneo/aether.nvim' },
}

local fallback = {
  colorscheme = 'rose-pine',
  background = 'dark',
}

local function extract_theme_data(data)
  if type(data) ~= 'table' then
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

local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, data = pcall(dofile, theme_file)
data = ok and extract_theme_data(data) or nil
data = data or fallback

local background = data.background == 'light' and 'light' or 'dark'

return vim.list_extend(vim.deepcopy(theme_plugins), {
  {
    name = 'omarchy-theme-background',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    priority = 1001,
    config = function()
      vim.o.background = background
    end,
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = data.colorscheme,
    },
  },
})
