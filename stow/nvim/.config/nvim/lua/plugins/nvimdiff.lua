-- Git difftool and mergetool (`nvim -d`, tool name nvimdiff)

return {
  {
    name = "nvimdiff",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      local group = vim.api.nvim_create_augroup("nvimdiff", { clear = true })

      local function setup_diff_window()
        if not vim.wo.diff then
          return
        end
        vim.wo.wrap = true
        vim.wo.number = true
        vim.wo.relativenumber = false
      end

      local function setup_keymaps()
        if vim.g.nvimdiff_keymaps then
          return
        end
        vim.g.nvimdiff_keymaps = true

        vim.opt.diffopt:append("followwrap")

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
        end

        -- ]h / [h are already wired to ]c / [c in diff mode by LazyVim gitsigns
        map("n", "<leader>gmu", ":diffupdate<CR>", "Diff update")
        map("n", "<leader>gmq", ":qa<CR>", "Diff quit all")
        map("n", "<leader>gmw", ":wqa<CR>", "Diff write all and quit")
        -- obtain / put: use built-in do and dp in diff windows
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = group,
        callback = function()
          setup_diff_window()
          setup_keymaps()
        end,
      })
    end,
  },
}
