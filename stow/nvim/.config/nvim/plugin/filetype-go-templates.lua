-- Go template filetype detection
vim.filetype.add({
  extension = {
    gohtml = 'gohtml',
  },
  pattern = {
    ['.*%.html%.tmpl$'] = 'gohtml',
  },
})

-- Map gohtml filetype to html treesitter parser
vim.treesitter.language.register('html', 'gohtml')