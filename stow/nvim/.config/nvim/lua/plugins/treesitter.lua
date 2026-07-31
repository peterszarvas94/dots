return {
  {
    "neovim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
    },
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({})
      vim.o.rtp = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime," .. vim.o.rtp

      treesitter.install({
        "bash",
        "css",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "odin",
        "ruby",
        "rust",
        "sql",
        "templ",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      local context = require("treesitter-context")
      context.setup({
        mode = "topline",
        max_lines = 3,
        multiline_threshold = 20,
        separator = "-",
      })
      vim.keymap.set("n", "<leader>cx", function()
        context.toggle()
      end, { desc = "TSContext toggle", silent = true })
    end,
  },
  {
    "joerdav/templ.vim",
    ft = "templ",
  },
}
