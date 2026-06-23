return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require 'fzf-lua'

      fzf.setup {
        fzf_colors = true,
        winopts = {
          border = 'rounded',
        },
        keymap = {
          fzf = {
            true,
            ['ctrl-a'] = 'toggle-all',
            ['alt-a'] = false,
          },
        },
        actions = {
          files = {
            true,
            ['ctrl-q'] = fzf.actions.file_sel_to_qf,
            ['alt-q'] = false,
          },
        },
      }

      local function picker(name, opts)
        return function()
          local fn = fzf[name]
          if fn then
            fn(opts or {})
            return
          end
          vim.notify('fzf-lua picker not available: ' .. name, vim.log.levels.WARN)
        end
      end

      vim.keymap.set('n', '<leader>sr', picker 'oldfiles', { desc = 'Search Recently opened files' })
      vim.keymap.set('n', '<leader>sf', picker 'files', { desc = 'Search Files' })
      vim.keymap.set('n', '<leader>sn', picker('files', { cwd = vim.fn.stdpath 'config' }), { desc = 'Search Nvim files' })
      vim.keymap.set('n', '<leader>sd', picker('files', { cwd = vim.fn.expand '~' .. '/projects/dots/' }), { desc = 'Search Dotfiles' })
      vim.keymap.set('n', '<leader>sl', picker 'live_grep', { desc = 'Search by Livegrep' })
      vim.keymap.set('n', '<leader>sh', picker 'helptags', { desc = 'Search Help' })
      vim.keymap.set('n', '<leader>sw', picker 'grep_cword', { desc = 'Search current Word' })
      vim.keymap.set('n', '<leader>sc', picker 'blines', { desc = 'Search Current buffer' })
      vim.keymap.set('n', '<leader>so', function()
        local word = vim.fn.expand '<cword>'
        fzf.blines { query = word }
      end, { silent = true, desc = 'Search wOrd in current buffer' })
      vim.keymap.set('n', '<leader>sk', picker 'keymaps', { desc = 'Search Keymaps' })
      vim.keymap.set('n', '<leader>sg', picker 'git_commits', { desc = 'Search Commits' })
      vim.keymap.set('n', '<leader>sb', picker 'git_bcommits', { desc = 'Search Buffer commits' })
      vim.keymap.set('n', '<leader>ss', picker 'git_stash', { desc = 'Search Stash' })
      vim.keymap.set('n', '<leader>se', picker 'emoji', { desc = 'Search Emojis' })
      vim.keymap.set('n', '<leader>sm', picker 'marks', { desc = 'Search Marks' })
      vim.keymap.set('n', '<leader>su', picker 'buffers', { desc = 'Search bUffers' })
      vim.keymap.set('n', '<leader>lr', picker 'lsp_references', { desc = 'Lsp References' })
      vim.keymap.set({ 'n', 'v' }, '<leader>i', picker 'lsp_code_actions', { desc = 'Code actions / Imports' })
    end,
  },
}
