local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
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

-- :GitPush git push command
vim.cmd [[
  command! GP !git push
]]

-- vim.cmd 'highlight ColorColumn guibg=#1e1e2e'
vim.cmd 'highlight Normal ctermfg=none guifg=none guibg=none'
vim.cmd 'highlight NormalNC ctermfg=none guifg=none guibg=none'
vim.cmd 'highlight NvimTreeNormal guibg=none'
vim.cmd 'highlight TreesitterContext guibg=none'
-- vim.cmd 'highlight TreesitterContextSeparator guifg=#f9e2af'
vim.cmd 'highlight TreesitterContextLineNumber guibg=#f9e2af'
-- vim.cmd 'highlight TreesitterContextLineNumberBottom guifg=#f9e2af gui=underline'
vim.cmd 'highlight TreesitterContextBottom gui=none'
vim.cmd 'highlight CursorLineNr guifg=#b4befe'
vim.cmd 'highlight LineNr guifg=#7f849c'
vim.cmd 'highlight NvimTreeWinSeparator guifg=#7f849c guibg=none'
vim.cmd 'highlight WinSeparator guifg=#7f849c guibg=none'
