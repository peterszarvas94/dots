vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd 'startinsert'
  end,
})

vim.api.nvim_create_user_command('TerminalSmall', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end, {})

vim.api.nvim_create_user_command('TerminalOpen', function()
  vim.cmd 'term'
end, {})

vim.api.nvim_create_user_command('TerminalTab', function()
  vim.cmd 'tabnew | term'
end, {})

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.9)
  local height = opts.height or math.floor(vim.o.lines * 0.9)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 3)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    -- style = 'minimal',
    border = 'rounded', -- Rounded border
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function toggle_teminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
      vim.cmd 'startinsert'
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('TerminalFloat', toggle_teminal, {})

-- Terminal keymaps
vim.keymap.set('n', '<leader>to', ':TerminalOpen<CR>', { desc = 'Terminal Open', silent = true })
vim.keymap.set('n', '<leader>ts', ':TerminalSmall<CR>', { desc = 'Terminal Small', silent = true })
vim.keymap.set('n', '<leader>tf', ':TerminalFloat<CR>', { desc = 'Terminal Float', silent = true })
vim.keymap.set('n', '<leader>tt', ':TerminalTab<CR>', { desc = 'Terminal Tab', silent = true })
vim.keymap.set('t', '<C-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })
