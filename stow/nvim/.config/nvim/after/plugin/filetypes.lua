vim.filetype.add {
  extension = {
    templ = 'templ',
    astro = 'astro',
    gohtml = 'gohtml',
    markerb = 'markdown',
    ['html.erb'] = 'erb',
  },
  pattern = {
    ['.*%.erb'] = 'eruby',
    ['.*%.html%.erb'] = 'eruby',
    ['.*%.html%.tmpl$'] = 'gohtml',
    ['.*%.markerb$'] = 'markdown',
  },
}

-- Map filetypes to treesitter parsers
vim.treesitter.language.register('html', 'gohtml')
vim.treesitter.language.register('tsx', 'typescriptreact')
vim.treesitter.language.register('tsx', 'javascriptreact')
vim.treesitter.language.register('templ', 'templ')

-- Ensure .markerb always uses markdown ft
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.markerb',
  callback = function(args)
    vim.bo[args.buf].filetype = 'markdown'
  end,
})
