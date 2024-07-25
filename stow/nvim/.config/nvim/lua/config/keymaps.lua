local function keymap(mode, key, map, opts)
  vim.keymap.set(mode, key, map, opts)
end

keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- terminal
keymap('n', '<leader>to', ':term<CR>', { desc = '[T]erminal [O]pen', silent = true })
keymap('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- buffer
-- keymap('n', '<leader>bd', ':bd!<cr>', { desc = '[B]uffer [D]elete', silent = true })

-- explorer
-- set('n', '<leader>x', ':Explore<cr>', { desc = 'E[x]plorer', silent = true })

-- undotree
local function openUndoTree()
  vim.cmd 'UndotreeToggle'
  vim.cmd 'NvimTreeFindFileToggle'
end
keymap('n', '<leader>u', openUndoTree, { desc = '[U]ndootree' })

-- keep selection after indent
keymap({ 'v' }, '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
keymap({ 'v' }, '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
keymap({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
keymap({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- organize imports
keymap('n', '<leader>o', ':OrganizeImports<cr>', { desc = '[O]rganize Iports', silent = true })

-- quickfix list
keymap('n', '<C-[>', '<cmd>cprevious<cr>', { desc = 'Previous item in quickfix list', silent = true })
keymap('n', '<C-]>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix list', silent = true })

-- nvimtree
keymap('n', '<leader>x', ':NvimTreeFindFileToggle<CR>', { desc = 'E[x]plorer toggle - Nvimtree', silent = true })

-- treesitter context
keymap('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Previous to [C]ontext', silent = true })

-- neogit
-- keymap('n', '<leader>g', ':Neogit<CR>', { desc = 'Neo[G]it', silent = true })

-- fugitive
keymap('n', '<leader>gg', ':Git<CR>', { desc = '[G]it', silent = true })
keymap('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = '[G]it [D]iff', silent = true })

-- lazygit
-- keymap('n', '<leader>gl', ':tab LazyGit<CR>', { desc = '[G]it - [L]azygit', silent = true })

-- tabs
keymap('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew', silent = true })

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

keymap('n', '<leader>t1', ':lua Goto_tab(1)<CR>', { desc = 'Tab [1]', silent = true })
keymap('n', '<leader>t2', ':lua Goto_tab(2)<CR>', { desc = 'Tab [2]', silent = true })
keymap('n', '<leader>t3', ':lua Goto_tab(3)<CR>', { desc = 'Tab [3]', silent = true })
keymap('n', '<leader>t4', ':lua Goto_tab(4)<CR>', { desc = 'Tab [4]', silent = true })
keymap('n', '<leader>t5', ':lua Goto_tab(5)<CR>', { desc = 'Tab [5]', silent = true })
keymap('n', '<leader>t6', ':lua Goto_tab(6)<CR>', { desc = 'Tab [6]', silent = true })
keymap('n', '<leader>t7', ':lua Goto_tab(7)<CR>', { desc = 'Tab [7]', silent = true })
keymap('n', '<leader>t8', ':lua Goto_tab(8)<CR>', { desc = 'Tab [8]', silent = true })
keymap('n', '<leader>t9', ':lua Goto_tab(9)<CR>', { desc = 'Tab [9]', silent = true })
keymap('n', '<leader>t0', ':lua Goto_tab(10)<CR>', { desc = 'Tab [10]', silent = true })

-- Set tabline to display only the file name

-- Define a function to prompt for input and run the command
function RenameTab()
  local input = vim.fn.input 'New tabname: '
  vim.cmd(':LualineRenameTab ' .. input)
end

-- Set the keymap to trigger the function with the 'w' key
keymap('n', '<leader>tr', ':lua RenameTab()<CR>', { desc = '[T]ab [R]ename', silent = true })

-- colorizer
keymap('n', '<leader>ct', ':ColorizerToggle<CR>', { desc = '[C]olorizer [T]oggle', silent = true })

-- gd

function JumpToDefinition()
  local org_path = vim.api.nvim_buf_get_name(0) -- Get the current buffer's name

  -- Navigate to the definition
  vim.api.nvim_command 'normal gd'

  -- Wait for the LSP server response
  vim.wait(100, function() end)

  local new_path = vim.api.nvim_buf_get_name(0) -- Get the new buffer's name after navigation
  if not (org_path == new_path) then
    -- If the buffer has changed, create a new tab for the original file
    vim.api.nvim_command '0tabnew %'

    -- Restore the cursor position
    vim.api.nvim_command('b ' .. org_path)
    vim.api.nvim_command 'normal `"'

    -- Switch to the original tab
    vim.api.nvim_command 'normal gt'
  else
    -- If the buffer hasn't changed, switch to the existing tab
    vim.api.nvim_command 'normal gt'
  end
end

-- Map the function to a key combination
keymap('n', '<leader>td', ':lua JumpToDefinition()<CR>', { desc = '[T]ab - go to [D]efinition', silent = true })

-- Obsidian
keymap('n', '<leader>bo', ':ObsidianOpen<CR>', { desc = 'O[b]sidian [O]pen', silent = true })
-- keymap('n', '<leader>bt', ':ObsidianToday<CR>', { desc = 'O[b]sidian [T]oday', silent = true })
-- keymap('n', '<leader>by', ':ObsidianYesterday<CR>', { desc = 'O[b]sidian [Y]esterday', silent = true })
keymap('n', '<leader>bm', ':ObsidianTemplate<CR>', { desc = 'O[b]sidian te[M]plate', silent = true })

-- split
keymap('n', '<M-.>', '<C-w>5>', { desc = 'Resize split +5 vertically', silent = true })
keymap('n', '<M-,>', '<C-w>5<', { desc = 'Resize split -5 vertically', silent = true })
keymap('n', '<M-=>', '<C-w>+', { desc = 'Resize split +1 horizontally', silent = true })
keymap('n', '<M-->', '<C-w>-', { desc = 'Resize split -1 horizontally', silent = true })

-- eslint
-- vim.api.nvim_create_user_command('Eslint', function()
--   vim.cmd '!eslint_d %'
-- end, {})

-- keymap('n', '<leader>l', ':Eslint<CR>', { desc = 'Es[L]int', silent = true })

-- copy buffer
keymap('n', '<leader>y', 'ggVGy', { desc = '[Y]ank buffer', silent = true })

-- conceal level
keymap('n', '<leader>c0', ':set conceallevel=0<CR>', { desc = '[C]onceal [L]evel 0', silent = true })
keymap('n', '<leader>c1', ':set conceallevel=1<CR>', { desc = '[C]onceal [L]evel 1', silent = true })
keymap('n', '<leader>c2', ':set conceallevel=2<CR>', { desc = '[C]onceal [L]evel 2', silent = true })
keymap('n', '<leader>c3', ':set conceallevel=3<CR>', { desc = '[C]onceal [L]evel 3', silent = true })

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

-- Optional: Bind to a key (e.g., <leader>d)
keymap('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = '[D]iagnostics [T]oggle', silent = true })
