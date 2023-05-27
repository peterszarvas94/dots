return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    'github/copilot.vim',
    -- event = "User AstroFile"
    lazy = false
  },
  {
    'tpope/vim-fugitive',
    event = "User AstroGitFile"
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    opts = {
      transparent = true;
    }
  },
  {
    'nvim-pack/nvim-spectre',     
  }
}
