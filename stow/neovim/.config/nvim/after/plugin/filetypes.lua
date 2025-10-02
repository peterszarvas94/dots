vim.filetype.add {
  extension = {
    templ = 'templ',
    astro = 'astro',
    gohtml = 'gohtml',
    ['html.erb'] = 'erb',
  },
  pattern = {
    ['.*%.html%.erb'] = 'eruby',
    ['.*%.erb'] = 'eruby',
    ['.*%.html%.tmpl$'] = 'gohtml',
  },
}

-- Map gohtml filetype to html treesitter parser
vim.treesitter.language.register('html', 'gohtml')
