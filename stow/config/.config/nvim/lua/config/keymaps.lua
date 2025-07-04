M = {}

-- lsp
M.setKeymapsOnAttach = function(bufnr)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[N]ame' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
end

-- ts_ls
M.setTsKeymap = function(bufnr)
  vim.keymap.set('n', '<leader>oi', ':OrganizeImports<CR>', { buffer = bufnr, desc = '[O]rganize [I]mports' })
end

-- telescope
M.setTelescopeKeymaps = function(builtin)
  vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch [R]ecently opened files' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files {
      cwd = vim.fn.stdpath 'config',
    }
  end, { desc = '[S]earch [N]vim files' })

  vim.keymap.set('n', '<leader>sd', function()
    builtin.find_files {
      cwd = vim.fn.expand '~' .. '/projects/dots/',
    }
  end, { desc = '[S]earch [D]otfiles' })

  vim.keymap.set('n', '<leader>sl', builtin.live_grep, { desc = '[S]earch by [L]ivegrep' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch dia[G]nostics' })
  vim.keymap.set('n', '<leader>sc', builtin.current_buffer_fuzzy_find, { desc = '[S]earch [C]urrent buffer' })
  vim.keymap.set('n', '<leader>so', function()
    local word = vim.fn.expand '<cword>'
    builtin.current_buffer_fuzzy_find { default_text = word }
  end, { silent = true, desc = '[S]earch w[O]rd in current buffer' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sg', builtin.git_commits, { desc = '[S]earch [C]ommits' })
  vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, { desc = '[S]earch [B]uffer commits' })
  vim.keymap.set('n', '<leader>ss', builtin.git_stash, { desc = '[S]earch [S]tash' })
  vim.keymap.set('n', '<leader>se', builtin.symbols, { desc = '[S]earch [E]mojis' })
  vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
  vim.keymap.set('n', '<leader>su', builtin.buffers, { desc = '[S]earch b[U]ffers' })
  vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = '[L]sp [R]eferences' })
end

-- unbind space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- source
vim.keymap.set('n', '<leader><leader>f', ':source %<CR>', { desc = 'Source [F]ile', silent = true })
vim.keymap.set('n', '<leader><leader>l', ':.lua<CR><CR>', { desc = 'Source [L]ine(s)', silent = true })
vim.keymap.set('v', '<leader><leader>l', ':lua<CR><CR>', { desc = 'Source [L]ine(s)', silent = true })

-- j->gj, k->gk
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostics list' })

-- terminal
vim.keymap.set('n', '<leader>to', ':term<CR>', { desc = '[T]erminal [O]pen', silent = true })
vim.keymap.set('n', '<leader>ts', ':TerminalSmall<CR>', { desc = '[T]erminal [S]mall', silent = true })
vim.keymap.set('n', '<leader>f', ':TerminalFloat<CR>', { desc = 'Terminal [F]loat', silent = true })
vim.keymap.set('n', '<leader>tt', ':TerminalTab<CR>', { desc = '[T]erminal [T]ab', silent = true })
vim.keymap.set('t', '<C-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew', silent = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = '[T]ab [C]lose', silent = true })

-- tmux
vim.keymap.set('n', '<leader>tm', ':Telescope tmux sessions<CR>', { desc = '[T][m]ux sessions', silent = true })

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
vim.keymap.set('n', '[c', ':TSGoToContext<CR>', { desc = 'Previous to [C]ontext', silent = true })

-- git
vim.keymap.set('n', '<leader>gg', ':Git<CR>', { desc = 'Fu[G]itive', silent = true })
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = '[G]it [D]iff', silent = true })
vim.keymap.set('n', '<leader>gp', ':!git push<CR>', { desc = '[G]it [P]ush', silent = true })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame', silent = true })

-- gp.nvim
vim.keymap.set({ 'n', 'v' }, '<leader>gn', ':GpChatNew<CR>', { desc = '[G]pChat[N]ew', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gt', ':GpChatToggle<CR>', { desc = '[G]pChat[T]oggle', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gf', ':GpChatFinder<CR>', { desc = '[G]pChat [F]inder', silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>gx', ':GpChatDelete<CR>', { desc = '[G]pChat [D]elete', silent = true })

-- Obsidian
vim.keymap.set('n', '<leader>oo', ':ObsidianOpen<CR>', { desc = '[O]bsidian [O]pen', silent = true })
vim.keymap.set('n', '<leader>ot', ':ObsidianTemplate<CR>', { desc = '[O]bsidian [T]emplate', silent = true })

-- split (M = alt or option, D = CMD on mac)
vim.keymap.set('n', '<M-.>', '<C-w>5>', { desc = 'Resize split +5 vertically', silent = true })
vim.keymap.set('n', '<M-,>', '<C-w>5<', { desc = 'Resize split -5 vertically', silent = true })
vim.keymap.set('n', '<M-=>', '<C-w>+', { desc = 'Resize split +1 horizontally', silent = true })
vim.keymap.set('n', '<M-->', '<C-w>-', { desc = 'Resize split -1 horizontally', silent = true })

-- buffer
vim.keymap.set('n', '<leader>y', 'ggVGy', { desc = '[Y]ank buffer', silent = true })
vim.keymap.set('n', '<leader>v', 'ggVG', { desc = '[V]isual select buffer', silent = true })
vim.keymap.set('n', '<leader>p', 'ggVGp', { desc = '[P]aste to buffer', silent = true })
vim.keymap.set('n', '<leader>bo', ':BufOnly<CR>', { desc = '[B]uffers close, keep [O]nly this', silent = true })

-- conceal level
-- vim.keymap.set('n', '<leader>l0', ':set conceallevel=0<CR>', { desc = 'Conceal [L]evel 0', silent = true })
-- vim.keymap.set('n', '<leader>l2', ':set conceallevel=2<CR>', { desc = 'Conceal [L]evel 2', silent = true })

-- toggle diagnostics
vim.keymap.set('n', '<leader>dt', ':ToggleDiagnostics<CR>', { desc = '[D]iagnostics [T]oggle', silent = true })

-- relative line numbers
vim.keymap.set('n', '<leader>ro', ':RelativeNumbersOn<CR>', { desc = '[R]elative numbers [O]n', silent = true })
vim.keymap.set('n', '<leader>rf', ':RelativeNumbersOff<CR>', { desc = '[R]elative numbers o[F]f', silent = true })
vim.keymap.set('n', '<leader>rt', ':RelativeNumbersToggle<CR>', { desc = '[R]elative numbers [T]oggle', silent = true })

-- nvimtree
vim.keymap.set('n', '<leader>x', ':NvimTreeToggle<CR>', { desc = '[N]vimTree [T]oggle', silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { desc = '[N]vimTree [F]ind file', silent = true })

-- markdown
vim.keymap.set('n', '<leader>ms', ':GithubPreviewStart<CR>', { desc = '[M]arkdown [S]tart', silent = true })
vim.keymap.set('n', '<leader>mp', ':GithubPreviewStop<CR>', { desc = '[M]arkdown sto[P]', silent = true })
vim.keymap.set('n', '<leader>mt', ':GithubPreviewToggle<CR>', { desc = '[M]arkdown [T]oggle', silent = true })

-- showing which key window
vim.keymap.set('n', '<leader>k', ':WhichKey<CR>', { desc = 'Which[K]ey', silent = true })

-- show colors
vim.keymap.set('n', '<leader>c', ':ColorizerToggle<CR>', { desc = '[C]olorizer Toggle', silent = true })

-- focus floating window
vim.keymap.set('n', '<C-w>f', ':FocusFloatingWindow<CR>', { noremap = true, silent = true })

-- find and replace in quickfix list
vim.keymap.set('n', '<M-f>', ':FindAndReplaceInQuickfix<CR>', { desc = '[F]ind and replace', silent = true })

vim.keymap.set('n', '<leader>i', function()
  require('actions-preview').code_actions()
end, { desc = 'Code actions / [I]mports', silent = true })

-- harpoon
vim.keymap.set('n', '<leader>hs', ':HarpoonTelescope<CR>', { desc = '[H]arpoon tele[S]cope', silent = true })
vim.keymap.set('n', '<leader>w', ':HarpoonToggle<CR>', { desc = 'Harpoon toggle [W]indow', silent = true })
vim.keymap.set('n', '<leader>a', ':HarpoonAdd<CR>', { desc = 'Harpoon [A]dd', silent = true })
vim.keymap.set('n', '<leader>hn', ':HarpoonNext<CR>', { desc = '[H]arpoon [N]ext', silent = true })
vim.keymap.set('n', '<leader>hp', ':HarpoonPrevious<CR>', { desc = '[H]arpoon [P]revious', silent = true })
for i = 1, 8 do
  vim.keymap.set('n', string.format('<leader>%d', i), string.format(':HarpoonSelect %d<CR>', i), { desc = string.format('Harpoon [%d]', i), silent = true })
end

-- format
-- vim.keymap.set('n', '<leader>f', ':Format<cr>', { desc = '[F]ormat', silent = true })

-- marks
vim.keymap.set('n', '<leader>dm', function()
  require('marks').delete_line()
end, { desc = '[D]eleme [M]ark on line', silent = true })

return M
