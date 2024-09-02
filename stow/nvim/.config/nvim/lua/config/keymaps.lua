local function set(mode, key, map, opts)
  vim.keymap.set(mode, key, map, opts)
end

set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- j->gj, k->gk
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- terminal
set('n', '<leader>to', ':term<CR>', { desc = '[T]erminal [O]pen', silent = true })
set('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- keep selection after indent
set('v', '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
set('v', '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- quickfix list
set('n', '<C-[>', '<cmd>cprevious<cr>', { desc = 'Previous item in quickfix list', silent = true })
set('n', '<C-]>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix list', silent = true })

-- treesitter context
set('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Previous to [C]ontext', silent = true })

-- fugitive
set('n', '<leader>gg', ':Git<CR>', { desc = 'Fu[G]itive', silent = true })
set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = '[G]it [D]iff', silent = true })
set('n', '<leader>gp', ':!git push<CR>', { desc = '[G]it [P]ush', silent = true })
set('n', '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame', silent = true })

-- tabs
set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew', silent = true })

-- Define a function to prompt for input and run the command
function RenameTab()
  local input = vim.fn.input 'New tabname: '
  vim.cmd(':LualineRenameTab ' .. input)
end

-- Set the keymap to trigger the function with the 'w' key
set('n', '<leader>tr', ':lua RenameTab()<CR>', { desc = '[T]ab [R]ename', silent = true })

-- Obsidian
set('n', '<leader>oo', ':ObsidianOpen<CR>', { desc = '[O]bsidian [O]pen', silent = true })
set('n', '<leader>ot', ':ObsidianTemplate<CR>', { desc = '[O]bsidian [T]emplate', silent = true })

-- split
set('n', '<M-.>', '<C-w>5>', { desc = 'Resize split +5 vertically', silent = true })
set('n', '<M-,>', '<C-w>5<', { desc = 'Resize split -5 vertically', silent = true })
set('n', '<M-=>', '<C-w>+', { desc = 'Resize split +1 horizontally', silent = true })
set('n', '<M-->', '<C-w>-', { desc = 'Resize split -1 horizontally', silent = true })

-- go to word visual mode
set('n', '<M-v>', 'viw', { desc = 'Go to word visual mode', silent = true })

-- buffer
set('n', '<leader>y', 'ggVGy', { desc = '[Y]ank buffer', silent = true })
set('n', '<leader>v', 'ggVG', { desc = '[V]isual select buffer', silent = true })
set('n', '<leader>p', 'ggVGp', { desc = '[P]aste to buffer', silent = true })

-- conceal level
set('n', '<leader>l0', ':set conceallevel=0<CR>', { desc = 'Conceal [L]evel 0', silent = true })
set('n', '<leader>l2', ':set conceallevel=2<CR>', { desc = 'Conceal [L]evel 2', silent = true })

-- Function to toggle diagnostics
local diagnostics_active = true

function _G.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    print 'Diagnostics enabled'
  else
    vim.diagnostic.disable()
    print 'Diagnostics disabled'
  end
end

-- Create a command for toggling diagnostics
vim.api.nvim_create_user_command('ToggleDiagnostics', 'lua _G.toggle_diagnostics()', {})
set('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = '[D]iagnostics [T]oggle', silent = true })

-- Define the function that moves the current window to the left
local function relOn()
  vim.o.relativenumber = true
end

local function relOff()
  vim.o.relativenumber = false
end

vim.api.nvim_create_user_command('RelOn', relOn, {})
vim.api.nvim_create_user_command('RelOff', relOff, {})

set('n', '<leader>x', ':NvimTreeToggle<CR>', { desc = 'NvimTree e[X]plorer', silent = true })
set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = '[U]ndooTree', silent = true })
