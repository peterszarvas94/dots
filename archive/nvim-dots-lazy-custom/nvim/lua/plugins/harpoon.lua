return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
  config = function()
    local harpoon = require 'harpoon'
    local fzf = require 'fzf-lua'
    harpoon:setup()

    -- Harpoon UI configuration
    local toggle_opts = {
      border = 'rounded',
      title_pos = 'center',
      ui_width_ratio = 0.8,
      title = ' Harpoon ',
      height_in_lines = 12,
    }

    local function toggle_fzf(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      fzf.fzf_exec(file_paths, {
        prompt = 'Harpoon> ',
        previewer = 'builtin',
        actions = {
          ['default'] = function(selected)
            if not selected or not selected[1] then
              return
            end
            vim.cmd.edit(selected[1])
          end,
        },
      })
    end

    -- User commands
    vim.api.nvim_create_user_command('HarpoonTelescope', function()
      toggle_fzf(harpoon:list())
    end, {})

    vim.api.nvim_create_user_command('HarpoonToggle', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
    end, {})

    vim.api.nvim_create_user_command('HarpoonAdd', function()
      harpoon:list():add()
    end, {})

    vim.api.nvim_create_user_command('HarpoonNext', function()
      harpoon:list():next()
    end, {})

    vim.api.nvim_create_user_command('HarpoonPrevious', function()
      harpoon:list():prev()
    end, {})

    vim.api.nvim_create_user_command('HarpoonSelect', function(opts)
      local n = tonumber(opts.args)
      harpoon:list():select(n)
    end, { nargs = 1 })

    -- Harpoon keymaps
    vim.keymap.set('n', '<leader>hs', ':HarpoonTelescope<CR>', { desc = 'Harpoon teleScope', silent = true })
    vim.keymap.set('n', '<leader>w', ':HarpoonToggle<CR>', { desc = 'Harpoon toggle Window', silent = true })
    vim.keymap.set('n', '<leader>a', ':HarpoonAdd<CR>', { desc = 'Harpoon Add', silent = true })
    vim.keymap.set('n', '<leader>hn', ':HarpoonNext<CR>', { desc = 'Harpoon Next', silent = true })
    vim.keymap.set('n', '<leader>hp', ':HarpoonPrevious<CR>', { desc = 'Harpoon Previous', silent = true })
    for i = 1, 8 do
      vim.keymap.set('n', string.format('<leader>%d', i), string.format(':HarpoonSelect %d<CR>', i), { desc = string.format('Harpoon %d', i), silent = true })
    end
  end,
}
