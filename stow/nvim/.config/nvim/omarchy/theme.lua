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

local fallback_opts = {
  colorscheme = 'rose-pine',
}

local function extract_lazyvim_opts(spec)
  if type(spec) ~= 'table' then
    return nil
  end

  for _, entry in ipairs(spec) do
    if type(entry) == 'table' and entry[1] == 'LazyVim/LazyVim' and type(entry.opts) == 'table' then
      return vim.deepcopy(entry.opts)
    end
  end

  return nil
end

local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, spec = pcall(dofile, theme_file)
local lazyvim_opts = ok and extract_lazyvim_opts(spec) or nil

return vim.list_extend(vim.deepcopy(theme_plugins), {
  {
    'LazyVim/LazyVim',
    opts = lazyvim_opts or fallback_opts,
  },
})
