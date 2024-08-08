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
