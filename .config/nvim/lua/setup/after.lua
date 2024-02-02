require('lualine').setup {
  options = {
    theme = 'tokyonight',
  },
}

vim.cmd 'colorscheme tokyonight-night'

require('which-key').register {
  ['<leader>'] = {
    s = {
      name = '[S]earch',
    },
    b = {
      name = '[B]uffer',
    },
    h = {
      name = '[H]arpoon',
    },
    t = {
      name = '[T]erminal',
    },
  },
}

require('colorizer').setup({
  user_default_options = {
    RGB = true,          -- #RGB hex codes
    RRGGBB = true,       -- #RRGGBB hex codes
    names = false,       -- "Name" codes like Blue or blue
    RRGGBBAA = true,     -- #RRGGBBAA hex codes
    AARRGGBB = true,     -- 0xAARRGGBB hex codes
    rgb_fn = true,       -- CSS rgb() and rgba() functions
    hsl_fn = true,       -- CSS hsl() and hsla() functions
    css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = true,                                 -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
    always_update = false
  },
})

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "go",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "yaml",
    "lua",
    "rust",
    "toml",
    "markdown",
    "jsdoc",
    "bash",
  },
  highlight = {
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
---@diagnostic disable-next-line
parser_config.templ = {
  install_info = {
    url = "https://github.com/vrischmann/tree-sitter-templ",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "templ",
}

local lspconfig = require 'lspconfig'
lspconfig.htmx.setup {
  filetypes = { "html", "templ" },
}
lspconfig.tailwindcss.setup {
  filetypes = { "html", "templ" },
  init_options = {
    userLanguages = {
      templ = "html",
    },
  },
}

-- :SetTab to set tab width 2, shiftwidth 2, expandtab
-- replace tabs with two spaces
function SetTab()
  vim.cmd('set tabstop=2 | set shiftwidth=2 | set expandtab')
  vim.cmd([[ %s/\t/  /ge | update ]])
end

-- vim.cmd([[
--   autocmd FileType * lua SetTab()
-- ]])

vim.cmd([[
  command! SetTab lua SetTab()
]])

-- set colorcolumn color
function SetColorColumn()
  vim.cmd('highlight ColorColumn ctermbg=0 guibg=#414868')
end

vim.cmd([[
  autocmd FileType * lua SetColorColumn()
]])

-- :GitPush git push command
vim.cmd([[
  command! GP !git push
]])
