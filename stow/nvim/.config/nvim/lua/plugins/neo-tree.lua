-- Show hidden files in Neo-tree by default; keep gitignored paths filtered.
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>x", "<leader>fe", remap = true, desc = "Explorer NeoTree (Root Dir)" },
    { "<leader>e", vim.diagnostic.open_float, desc = "Line Diagnostics" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
}
