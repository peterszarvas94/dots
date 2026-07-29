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
    return vim.deepcopy(fallback)
  end

  if type(data.colorscheme) == 'string' and data.colorscheme ~= '' then
    return {
      colorscheme = data.colorscheme,
      background = data.background == 'light' and 'light' or 'dark',
    }
  end

  for _, spec in ipairs(data) do
    local plugin = spec[1]
    if plugin == 'LazyVim/LazyVim' and type(spec.opts) == 'table' then
      local cs = spec.opts.colorscheme
      if type(cs) == 'string' and cs ~= '' then
        return {
          colorscheme = cs,
          background = spec.opts.background == 'light' and 'light' or 'dark',
        }
      end
    end
  end

  return vim.deepcopy(fallback)
end

local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, data = pcall(dofile, theme_file)
data = ok and extract_theme_data(data) or vim.deepcopy(fallback)

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
    dir = vim.fn.stdpath('config') .. '/local/lazyvim-stub',
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      if type(opts) == 'table' and type(opts.colorscheme) == 'string' and opts.colorscheme ~= '' then
        pcall(vim.cmd.colorscheme, opts.colorscheme)
      end
    end,
    opts = {
      colorscheme = data.colorscheme,
      background = data.background,
    },
  },
})
