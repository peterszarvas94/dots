local harpoon = require 'harpoon'
local toggle_opts = {
  border = 'rounded',
  title_pos = 'center',
  ui_width_ratio = 0.40,
  title = ' Harpoon ',
}

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

vim.api.nvim_create_user_command('HarpoonTelescope', function()
  toggle_telescope(harpoon:list())
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
