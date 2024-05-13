vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- terminal
vim.keymap.set('n', '<leader>to', ':term<CR>', { desc = '[T]erminal [O]pen', silent = true })
vim.keymap.set('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- buffer
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', { desc = '[B]uffer [D]elete', silent = true })

-- explorer
-- vim.keymap.set('n', '<leader>x', ':Explore<cr>', { desc = 'E[x]plorer', silent = true })

-- undotree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr>', { desc = '[U]ndootree' })

-- keep selection after indent
vim.keymap.set({ 'v' }, '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
vim.keymap.set({ 'v' }, '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- organize imports
vim.keymap.set('n', '<leader>o', ':OrganizeImports<cr>', { desc = '[O]rganize Iports', silent = true })

-- quickfix list
vim.keymap.set('n', '<C-[>', '<cmd>cprevious<cr>', { desc = 'Previous item in quickfix list', silent = true })
vim.keymap.set('n', '<C-]>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix list', silent = true })

-- nvimtree
vim.keymap.set('n', '<leader>x', ':NvimTreeFindFileToggle<CR>', { desc = 'E[x]plorer toggle - Nvimtree', silent = true })

-- treesitter context
vim.keymap.set('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Previous to [C]ontext', silent = true })

-- neogit
vim.keymap.set('n', '<leader>g', ':Neogit<CR>', { desc = 'Neo[G]it', silent = true })

-- fugitive
-- vim.keymap.set('n', '<leader>gf', ':tab Git<CR>', { desc = '[G]it - [F]ugitive', silent = true })

-- lazygit
-- vim.keymap.set('n', '<leader>gl', ':tab LazyGit<CR>', { desc = '[G]it - [L]azygit', silent = true })

-- tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew', silent = true })

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

vim.keymap.set('n', '<leader>t1', ':lua Goto_tab(1)<CR>', { desc = 'Tab [1]', silent = true })
vim.keymap.set('n', '<leader>t2', ':lua Goto_tab(2)<CR>', { desc = 'Tab [2]', silent = true })
vim.keymap.set('n', '<leader>t3', ':lua Goto_tab(3)<CR>', { desc = 'Tab [3]', silent = true })
vim.keymap.set('n', '<leader>t4', ':lua Goto_tab(4)<CR>', { desc = 'Tab [4]', silent = true })
vim.keymap.set('n', '<leader>t5', ':lua Goto_tab(5)<CR>', { desc = 'Tab [5]', silent = true })
vim.keymap.set('n', '<leader>t6', ':lua Goto_tab(6)<CR>', { desc = 'Tab [6]', silent = true })
vim.keymap.set('n', '<leader>t7', ':lua Goto_tab(7)<CR>', { desc = 'Tab [7]', silent = true })
vim.keymap.set('n', '<leader>t8', ':lua Goto_tab(8)<CR>', { desc = 'Tab [8]', silent = true })
vim.keymap.set('n', '<leader>t9', ':lua Goto_tab(9)<CR>', { desc = 'Tab [9]', silent = true })
vim.keymap.set('n', '<leader>t0', ':lua Goto_tab(10)<CR>', { desc = 'Tab [10]', silent = true })

-- Set tabline to display only the file name

-- Define a function to prompt for input and run the command
function RenameTab()
  local input = vim.fn.input 'New tabname: '
  vim.cmd(':LualineRenameTab ' .. input)
end

-- Set the keymap to trigger the function with the 'w' key
vim.keymap.set('n', '<leader>tr', ':lua RenameTab()<CR>', { desc = '[T]ab [R]ename', silent = true })

-- colorizer
vim.keymap.set('n', '<leader>ct', ':ColorizerToggle<CR>', { desc = '[C]olorizer [T]oggle', silent = true })

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
vim.keymap.set('n', '<Leader>td', ':lua JumpToDefinition()<CR>', { desc = '[T]ab - go to [D]efinition', silent = true })
