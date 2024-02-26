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

-- set colorcolumn color
function SetColorColumn()
  vim.cmd 'highlight ColorColumn ctermbg=0 guibg=#414868'
end

vim.cmd [[
  autocmd FileType * lua SetColorColumn()
]]

-- :GitPush git push command
vim.cmd [[
  command! GP !git push
]]
