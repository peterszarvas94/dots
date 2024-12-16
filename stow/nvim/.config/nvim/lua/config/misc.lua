-- highlight on yank
local yank_highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_highlight_group,
  pattern = '*',
})

vim.filetype.add {
  extension = {
    templ = 'templ',
    astro = 'astro',
  },
}

-- set spaces as tabs
function Spaces()
  vim.cmd 'set tabstop=2 | set shiftwidth=2 | set expandtab'
  vim.cmd [[ %s/\t/  /ge | update ]]
end

vim.cmd [[
  command! Spaces lua Spaces()
]]

-- set tabs as tabs
function Tabs()
  vim.cmd 'set tabstop=2 | set shiftwidth=2 | set noexpandtab'
  vim.cmd [[ %s/  /\t/ge | update ]]
end

vim.cmd [[
  command! Tabs lua Tabs()
]]

local function open_floating_terminal()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Get editor dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Calculate position for centering the floating window
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Define window options
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded', -- Rounded border
  }

  -- Open the floating window
  vim.api.nvim_open_win(buf, true, opts)

  -- Start terminal in the buffer
  vim.fn.termopen(vim.o.shell)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')

  -- Ensure the terminal respects the editor's theme
  vim.cmd 'setlocal winhighlight=Normal:Normal,FloatBorder:Normal'
end

-- Create a command to open the floating terminal
vim.api.nvim_create_user_command('FloatingTerm', open_floating_terminal, {})

-- toggle diagnostics
local diagnostics_active = true
local function toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    print 'Diagnostics enabled'
  else
    vim.diagnostic.disable()
    print 'Diagnostics disabled'
  end
end
vim.api.nvim_create_user_command('ToggleDiagnostics', toggle_diagnostics, {})

-- relative line numbers
vim.api.nvim_create_user_command('RelOn', function()
  vim.o.relativenumber = true
end, {})
vim.api.nvim_create_user_command('RelOff', function()
  vim.o.relativenumber = false
end, {})

-- focus floating window
local function focus_floating_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end
vim.api.nvim_create_user_command('FocusFloatingWindow', focus_floating_window, {})

-- find and replace in quickfix list
local function find_and_replace_in_quickfix()
  local find = vim.fn.input 'Find: '
  if find == '' then
    print 'Find can not be empty'
    return
  end

  local replace = vim.fn.input 'Replace: '

  vim.cmd(string.format('cdo %%s/%s/%s/gc', vim.fn.escape(find, '/'), vim.fn.escape(replace, '/')))
end
vim.api.nvim_create_user_command('FindAndReplaceInQuickfix', find_and_replace_in_quickfix, {})

-- go to treesitter context
local function go_to_treesitter_context()
  require('treesitter-context').go_to_context(vim.v.count1)
end
vim.api.nvim_create_user_command('TSGoToContext', go_to_treesitter_context, {})
