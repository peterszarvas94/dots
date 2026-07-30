return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff4_mixed",
            winbar_info = true,
          },
        },
      })
    end,
  },
}
