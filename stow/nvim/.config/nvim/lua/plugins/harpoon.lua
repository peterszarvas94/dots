return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    ---@diagnostic disable-next-line

    harpoon:setup()

    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<leader>hs', function()
      toggle_telescope(harpoon:list())
    end, { desc = '[H]arpoon tele[S]cope', silent = true })

    vim.keymap.set('n', '<leader>ht', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [T]oggle window', silent = true })

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon [A]dd', silent = true })

    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():next()
    end, { desc = '[H]arpoon [N]ext', silent = true })

    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():prev()
    end, { desc = '[H]arpoon [P]revious', silent = true })

    vim.keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, { desc = '[H]arpoon select [1]', silent = true })
    vim.keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, { desc = '[H]arpoon select [2]', silent = true })
    vim.keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, { desc = '[H]arpoon select [3]', silent = true })
    vim.keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, { desc = '[H]arpoon select [4]', silent = true })
    vim.keymap.set('n', '<leader>5', function()
      harpoon:list():select(5)
    end, { desc = '[H]arpoon select [5]', silent = true })
    vim.keymap.set('n', '<leader>6', function()
      harpoon:list():select(6)
    end, { desc = '[H]arpoon select [6]', silent = true })
    vim.keymap.set('n', '<leader>7', function()
      harpoon:list():select(7)
    end, { desc = '[H]arpoon select [7]', silent = true })
    vim.keymap.set('n', '<leader>8', function()
      harpoon:list():select(8)
    end, { desc = '[H]arpoon select [8]', silent = true })
  end,
}
