-- Show tracked dotfiles (e.g. .gitignore); hide only gitignored paths.
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
}
