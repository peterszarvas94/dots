local fallback = {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        styles = {
          italic = false,
          bold = false,
        },
      }
    end,
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'rose-pine',
    },
  },
}

local theme_file = vim.fn.expand '~/.config/omarchy/current/theme/neovim.lua'
local ok, spec = pcall(dofile, theme_file)
if ok and type(spec) == 'table' then
  return spec
end

return fallback
