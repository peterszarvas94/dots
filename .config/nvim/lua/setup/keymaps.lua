vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    file_ignore_patterns = { 'node_modules', '.git' },
  },
  pickers = {
    live_grep = {
      additional_args = function(_)
        return { '--hidden' }
      end,
    },
    find_files = {
      hidden = true,
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = '[S]earch [R]ecently opened files' })
vim.keymap.set('n', '<leader>sc', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[S]earch [C]urrent file' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sl', require('telescope.builtin').live_grep, { desc = '[S]earch by [L]ivegrep' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = '[S]earch [G]it' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })

---@diagnostic disable-next-line missing-fields
require('nvim-treesitter.configs').setup {
  modules = { 'go', 'lua', 'tsx', 'typescript' },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local on_attach = function(_, bufnr)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]cchtion' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Type [D]efinition' })
  vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
    { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
  vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    { buffer = bufnr, desc = '[W]orkspace [S]ymbols' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documentation' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = '[G]oto [D]eclaration' })
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [A]dd Folder' })
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
    { buffer = bufnr, desc = '[W]orkspace [R]emove Folder' })
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = '[W]orkspace [L]ist Folders' })
end

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = function()
        on_attach()
        require('which-key').register {
          ['<leader>'] = {
            c = {
              name = '[C]ode',
            },
            d = {
              name = '[D]ocument',
            },
            r = {
              name = '[R]e',
            },
            w = {
              name = '[W]orkspace',
            },
          },
        }
      end,
      settings = servers[server_name],
    }
  end,
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

---@diagnostic disable-next-line missing-fields
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-a>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-- terminal
vim.keymap.set('n', '<leader>to', ':term<CR>', { desc = '[t]erminal [o]pen', silent = true })
vim.keymap.set('t', '<c-e>', '<c-\\><c-n>', { desc = 'Escape terminal mode', silent = true })

-- buffer
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', { desc = '[B]uffer [D]elete', silent = true })

-- harpoon
local harpoon = require('harpoon')
---@diagnostic disable-next-line
harpoon:setup()

-- open harpoon window
vim.keymap.set('n', '<leader>ht',
  function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end,
  { desc = '[H]arpoon [T]oggle window', silent = true }
)
-- add current file to harpoon
vim.keymap.set('n', '<leader>ha',
  function()
    harpoon:list():append()
  end,
  { desc = '[H]arpoon [A]dd', silent = true }
)
vim.keymap.set('n', '<leader>hn',
  function()
    harpoon:list():next()
  end,
  {desc = '[H]arpoon [N]ext', silent = true }
)
vim.keymap.set('n', '<leader>hp',
  function()
    harpoon:list():prev()
  end,
  {desc = '[H]arpoon [P]revious', silent = true }
)
vim.keymap.set('n', '<leader>h1',
  function()
    harpoon:list():select(1)
  end,
  {desc = '[H]arpoon select [1]', silent = true }
)
vim.keymap.set('n', '<leader>h2',
  function()
    harpoon:list():select(2)
  end,
  {desc = '[H]arpoon select [2]', silent = true }
)
vim.keymap.set('n', '<leader>h3',
  function()
    harpoon:list():select(3)
  end,
  {desc = '[H]arpoon select [3]', silent = true }
)
vim.keymap.set('n', '<leader>h4',
  function()
    harpoon:list():select(4)
  end,
  {desc = '[H]arpoon select [4]', silent = true }
)
vim.keymap.set('n', '<leader>h5',
  function()
    harpoon:list():select(5)
  end,
  {desc = '[H]arpoon select [5]', silent = true }
)
vim.keymap.set('n', '<leader>h6',
  function()
    harpoon:list():select(6)
  end,
  {desc = '[H]arpoon select [6]', silent = true }
)
vim.keymap.set('n', '<leader>h7',
  function()
    harpoon:list():select(7)
  end,
  {desc = '[H]arpoon select [7]', silent = true }
)
vim.keymap.set('n', '<leader>h8',
  function()
    harpoon:list():select(8)
  end,
  {desc = '[H]arpoon select [8]', silent = true }
)

-- explorer
vim.keymap.set('n', '<leader>x', ':Explore<cr>', { desc = 'E[x]plorer', silent = true })

-- undotree
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<cr>', { desc = '[U]ndootree' })

-- format with lsp
local function format_with_lsp()
  vim.lsp.buf.format()
end

vim.keymap.set({ 'n', 'v' }, '<leader>f', format_with_lsp, { desc = '[F]ormat' })

local function formatWithPrettier()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local filetype = vim.bo.filetype
  print(filetype)
  -- local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  local fake_filename = 'fake.' .. filetype
  local prettier_cmd = 'run-prettier --stdin-filepath ' .. fake_filename
  local output = vim.fn.system(prettier_cmd, table.concat(lines, '\n'))
  if output == nil then
    return
  else
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, '\n'))
  end
end

vim.keymap.set({ 'n' }, '<leader>p', formatWithPrettier, { desc = '[P]rettier', noremap = true, silent = true })

-- keep selection after indent
vim.keymap.set({ 'v' }, '<', '<gv', { desc = 'Indent left', noremap = true, silent = true })
vim.keymap.set({ 'v' }, '>', '>gv', { desc = 'Indent right', noremap = true, silent = true })

-- move selected lines vertically (with correct indentation)
vim.keymap.set({ 'v' }, 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up', noremap = true, silent = true })
vim.keymap.set({ 'v' }, 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down', noremap = true, silent = true })
