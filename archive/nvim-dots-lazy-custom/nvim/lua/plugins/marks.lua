return {
  'chentoast/marks.nvim',
  event = 'VeryLazy',
  config = function()
    require('marks').setup {}

    -- Marks keymap
    vim.keymap.set('n', '<leader>dm', function()
      require('marks').delete_line()
    end, { desc = 'Delete Mark on line', silent = true })
  end,
}
