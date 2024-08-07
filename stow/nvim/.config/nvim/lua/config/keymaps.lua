local function set(mode, key, map, opts)
  vim.keymap.set(mode, key, map, opts)
end

set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- terminal
set('n', '<leader>to', ':term<CR>', { desc = '[T]erminal [O]pen', silent = true })
set('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- explorer -> replaced with nvimtree
-- set('n', '<leader>x', ':Explore<cr>', { desc = 'E[x]plorer', silent = true })

-- undotree
set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = '[U]ndootree' })

-- keep selection after indent
set({ 'v' }, '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
set({ 'v' }, '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- organize imports
set('n', '<leader>o', ':OrganizeImports<cr>', { desc = '[O]rganize Iports', silent = true })

-- quickfix list
set('n', '<C-[>', '<cmd>cprevious<cr>', { desc = 'Previous item in quickfix list', silent = true })
set('n', '<C-]>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix list', silent = true })

-- nvimtree
set('n', '<leader>x', ':NvimTreeFindFileToggle<CR>', { desc = 'E[x]plorer toggle - Nvimtree', silent = true })

-- treesitter context
set('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Previous to [C]ontext', silent = true })

-- fugitive
set('n', '<leader>gg', ':Git<CR>', { desc = '[G]it', silent = true })
set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = '[G]it [D]iff', silent = true })

-- tabs
set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew', silent = true })

function Goto_tab(tab_index)
  -- Check if the tab exists
  local total_tabs = vim.fn.tabpagenr '$'
  if tab_index > 0 and tab_index <= total_tabs then
    vim.cmd('tabnext ' .. tab_index)
  else
    print 'Tab not found!'
    vim.defer_fn(function()
      vim.cmd 'echo ""' -- Clear the message
    end, 1000)
  end
end

set('n', '<leader>t1', ':lua Goto_tab(1)<CR>', { desc = 'Tab [1]', silent = true })
set('n', '<leader>t2', ':lua Goto_tab(2)<CR>', { desc = 'Tab [2]', silent = true })
set('n', '<leader>t3', ':lua Goto_tab(3)<CR>', { desc = 'Tab [3]', silent = true })
set('n', '<leader>t4', ':lua Goto_tab(4)<CR>', { desc = 'Tab [4]', silent = true })
set('n', '<leader>t5', ':lua Goto_tab(5)<CR>', { desc = 'Tab [5]', silent = true })
set('n', '<leader>t6', ':lua Goto_tab(6)<CR>', { desc = 'Tab [6]', silent = true })
set('n', '<leader>t7', ':lua Goto_tab(7)<CR>', { desc = 'Tab [7]', silent = true })
set('n', '<leader>t8', ':lua Goto_tab(8)<CR>', { desc = 'Tab [8]', silent = true })
set('n', '<leader>t9', ':lua Goto_tab(9)<CR>', { desc = 'Tab [9]', silent = true })
set('n', '<leader>t0', ':lua Goto_tab(10)<CR>', { desc = 'Tab [10]', silent = true })

-- Set tabline to display only the file name

-- Define a function to prompt for input and run the command
function RenameTab()
  local input = vim.fn.input 'New tabname: '
  vim.cmd(':LualineRenameTab ' .. input)
end

-- Set the keymap to trigger the function with the 'w' key
set('n', '<leader>tr', ':lua RenameTab()<CR>', { desc = '[T]ab [R]ename', silent = true })

-- colorizer
set('n', '<leader>ct', ':ColorizerToggle<CR>', { desc = '[C]olorizer [T]oggle', silent = true })

-- Obsidian
set('n', '<leader>bo', ':ObsidianOpen<CR>', { desc = 'O[b]sidian [O]pen', silent = true })
set('n', '<leader>bm', ':ObsidianTemplate<CR>', { desc = 'O[b]sidian te[M]plate', silent = true })

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
set('n', '<leader>c0', ':set conceallevel=0<CR>', { desc = '[C]onceal [L]evel 0', silent = true })
set('n', '<leader>c1', ':set conceallevel=1<CR>', { desc = '[C]onceal [L]evel 1', silent = true })
set('n', '<leader>c2', ':set conceallevel=2<CR>', { desc = '[C]onceal [L]evel 2', silent = true })
set('n', '<leader>c3', ':set conceallevel=3<CR>', { desc = '[C]onceal [L]evel 3', silent = true })

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
