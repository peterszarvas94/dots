M = {}

-- lsp
M.setKeymapsOnAttach = function(bufnr)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto Definition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = 'Goto References' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Goto Implementation' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
end

-- ts_ls
M.setTsKeymap = function(bufnr)
  vim.keymap.set('n', '<leader>oi', ':OrganizeImports<CR>', { buffer = bufnr, desc = 'Organize Imports' })
end

-- telescope
M.setTelescopeKeymaps = function(builtin)
  vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = 'Search Recently opened files' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search Files' })
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files {
      cwd = vim.fn.stdpath 'config',
    }
  end, { desc = 'Search Nvim files' })

  vim.keymap.set('n', '<leader>sd', function()
    builtin.find_files {
      cwd = vim.fn.expand '~' .. '/projects/dots/',
    }
  end, { desc = 'Search Dotfiles' })

  vim.keymap.set('n', '<leader>sl', builtin.live_grep, { desc = 'Search by Livegrep' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current Word' })
  -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diaGnostics' })
  vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, { desc = 'Search Current buffer' })
  vim.keymap.set('n', '<leader>so', function()
    local word = vim.fn.expand '<cword>'
    builtin.current_buffer_fuzzy_find { default_text = word }
  end, { silent = true, desc = 'Search wOrd in current buffer' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
  vim.keymap.set('n', '<leader>sg', builtin.git_commits, { desc = 'Search Commits' })
  vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, { desc = 'Search Buffer commits' })
  vim.keymap.set('n', '<leader>ss', builtin.git_stash, { desc = 'Search Stash' })
  vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = 'Search Emojis' })
  vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Search Marks' })
  vim.keymap.set('n', '<leader>su', builtin.buffers, { desc = 'Search bUffers' })
  vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Lsp References' })
end

-- unbind space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- source
vim.keymap.set('n', '<leader><leader>f', ':source %<CR>', { desc = 'Source File', silent = true })
vim.keymap.set('n', '<leader><leader>l', ':.lua<CR><CR>', { desc = 'Source Line(s)', silent = true })
vim.keymap.set('v', '<leader><leader>l', ':lua<CR><CR>', { desc = 'Source Line(s)', silent = true })

-- j->gj, k->gk
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostics list' })

-- terminal
vim.keymap.set('n', '<leader>to', ':term<CR>', { desc = 'Terminal Open', silent = true })
vim.keymap.set('n', '<leader>ts', ':TerminalSmall<CR>', { desc = 'Terminal Small', silent = true })
vim.keymap.set('n', '<leader>tf', ':TerminalFloat<CR>', { desc = 'Terminal Float', silent = true })
vim.keymap.set('n', '<leader>tt', ':TerminalTab<CR>', { desc = 'Terminal Tab', silent = true })
vim.keymap.set('t', '<C-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Tab New', silent = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Tab Close', silent = true })

-- tmux
vim.keymap.set('n', '<leader>tm', ':Telescope tmux sessions<CR>', { desc = 'Tmux sessions', silent = true })

-- keep selection after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })

-- disable arrow keys
vim.keymap.set('n', '<left>', ':echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', ':echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', ':echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', ':echo "Use j to move!!"<CR>')

-- quickfix list
vim.keymap.set('n', '<C-[>', ':cprevious<CR>', { desc = 'Previous item in quickfix list', silent = true })
vim.keymap.set('n', '<C-]>', ':cnext<CR>', { desc = 'Next item in quickfix list', silent = true })

-- treesitter context
vim.keymap.set('n', '<leader>tc', ':TSGoToContext<CR>', { desc = 'Previous to Context', silent = true })

-- git
vim.keymap.set('n', '<leader>gg', ':Git<CR>', { desc = 'Fugitive', silent = true })
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = 'Git Diff', silent = true })
vim.keymap.set('n', '<leader>gp', ':!git push<CR>', { desc = 'Git Push', silent = true })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git Blame', silent = true })

-- gp.nvim
vim.keymap.set({ 'n', 'v' }, '<leader>gn', ':GpChatNew<CR>', { desc = 'GpChatNew', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gt', ':GpChatToggle<CR>', { desc = 'GpChatToggle', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gf', ':GpChatFinder<CR>', { desc = 'GpChat Finder', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gx', ':GpChatDelete<CR>', { desc = 'GpChat Delete', silent = true })

-- excalidraw
vim.keymap.set('n', '<leader>oe', ':ExcalidrawOpen<CR>', { desc = 'Obsidian Open', silent = true })

-- split (M = alt or option, D = CMD on mac)
vim.keymap.set('n', '<M-.>', '<C-w>5>', { desc = 'Resize split +5 vertically', silent = true })
vim.keymap.set('n', '<M-,>', '<C-w>5<', { desc = 'Resize split -5 vertically', silent = true })
vim.keymap.set('n', '<M-=>', '<C-w>+', { desc = 'Resize split +1 horizontally', silent = true })
vim.keymap.set('n', '<M-->', '<C-w>-', { desc = 'Resize split -1 horizontally', silent = true })

-- buffer
vim.keymap.set('n', '<leader>y', 'ggVGy', { desc = 'Yank buffer', silent = true })
vim.keymap.set('n', '<leader>v', 'ggVG', { desc = 'Visual select buffer', silent = true })
vim.keymap.set('n', '<leader>p', 'ggVGp', { desc = 'Paste to buffer', silent = true })
vim.keymap.set('n', '<leader>bo', ':BufOnly<CR>', { desc = 'Buffers close, keep Only this', silent = true })

-- conceal level
-- vim.keymap.set('n', '<leader>l0', ':set conceallevel=0<CR>', { desc = 'Conceal Level 0', silent = true })
-- vim.keymap.set('n', '<leader>l2', ':set conceallevel=2<CR>', { desc = 'Conceal Level 2', silent = true })

-- toggle diagnostics
vim.keymap.set('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = 'Diagnostics Toggle', silent = true })

-- relative line numbers
vim.keymap.set('n', '<leader>ro', ':RelativeNumbersOn<CR>', { desc = 'Relative numbers On', silent = true })
vim.keymap.set('n', '<leader>rf', ':RelativeNumbersOff<CR>', { desc = 'Relative numbers oFf', silent = true })
vim.keymap.set('n', '<leader>rt', ':RelativeNumbersToggle<CR>', { desc = 'Relative numbers Toggle', silent = true })

-- nvimtree
vim.keymap.set('n', '<leader>x', ':NvimTreeToggle<CR>', { desc = 'NvimTree Toggle', silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { desc = 'NvimTree Find file', silent = true })

-- markdown
vim.keymap.set('n', '<leader>ms', ':GithubPreviewStart<CR>', { desc = 'Markdown Start', silent = true })
vim.keymap.set('n', '<leader>mp', ':GithubPreviewStop<CR>', { desc = 'Markdown stoP', silent = true })
vim.keymap.set('n', '<leader>mt', ':GithubPreviewToggle<CR>', { desc = 'Markdown Toggle', silent = true })

-- showing which key window
vim.keymap.set('n', '<leader>k', ':WhichKey<CR>', { desc = 'WhichKey', silent = true })

-- show colors
vim.keymap.set('n', '<leader>c', ':ColorizerToggle<CR>', { desc = 'Colorizer Toggle', silent = true })

-- focus floating window
vim.keymap.set('n', '<C-w>f', ':FocusFloatingWindow<CR>', { noremap = true, silent = true })

-- find and replace in quickfix list
vim.keymap.set('n', '<M-f>', ':FindAndReplaceInQuickfix<CR>', { desc = 'Find and replace', silent = true })

vim.keymap.set('n', '<leader>i', function()
  require('actions-preview').code_actions()
end, { desc = 'Code actions / Imports', silent = true })

-- harpoon
vim.keymap.set('n', '<leader>hs', ':HarpoonTelescope<CR>', { desc = 'Harpoon teleScope', silent = true })
vim.keymap.set('n', '<leader>w', ':HarpoonToggle<CR>', { desc = 'Harpoon toggle Window', silent = true })
vim.keymap.set('n', '<leader>a', ':HarpoonAdd<CR>', { desc = 'Harpoon Add', silent = true })
vim.keymap.set('n', '<leader>hn', ':HarpoonNext<CR>', { desc = 'Harpoon Next', silent = true })
vim.keymap.set('n', '<leader>hp', ':HarpoonPrevious<CR>', { desc = 'Harpoon Previous', silent = true })
for i = 1, 8 do
  vim.keymap.set('n', string.format('<leader>%d', i), string.format(':HarpoonSelect %d<CR>', i), { desc = string.format('Harpoon %d', i), silent = true })
end

-- format
vim.keymap.set('n', '<leader>f', ':Format<cr>', { desc = 'Format', silent = true })

-- marks
vim.keymap.set('n', '<leader>dm', function()
  require('marks').delete_line()
end, { desc = 'Deleme Mark on line', silent = true })

return M
