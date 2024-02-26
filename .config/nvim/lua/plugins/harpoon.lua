return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    ---@diagnostic disable-next-line
    harpoon:setup()

    -- open harpoon window
    vim.keymap.set('n', '<leader>ht', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [T]oggle window', silent = true })
    -- add current file to harpoon
    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = '[H]arpoon [A]dd', silent = true })
    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():next()
    end, { desc = '[H]arpoon [N]ext', silent = true })
    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():prev()
    end, { desc = '[H]arpoon [P]revious', silent = true })
    vim.keymap.set('n', '<leader>h1', function()
      harpoon:list():select(1)
    end, { desc = '[H]arpoon select [1]', silent = true })
    vim.keymap.set('n', '<leader>h2', function()
      harpoon:list():select(2)
    end, { desc = '[H]arpoon select [2]', silent = true })
    vim.keymap.set('n', '<leader>h3', function()
      harpoon:list():select(3)
    end, { desc = '[H]arpoon select [3]', silent = true })
    vim.keymap.set('n', '<leader>h4', function()
      harpoon:list():select(4)
    end, { desc = '[H]arpoon select [4]', silent = true })
    vim.keymap.set('n', '<leader>h5', function()
      harpoon:list():select(5)
    end, { desc = '[H]arpoon select [5]', silent = true })
    vim.keymap.set('n', '<leader>h6', function()
      harpoon:list():select(6)
    end, { desc = '[H]arpoon select [6]', silent = true })
    vim.keymap.set('n', '<leader>h7', function()
      harpoon:list():select(7)
    end, { desc = '[H]arpoon select [7]', silent = true })
    vim.keymap.set('n', '<leader>h8', function()
      harpoon:list():select(8)
    end, { desc = '[H]arpoon select [8]', silent = true })
  end,
}
