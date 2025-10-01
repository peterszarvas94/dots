-- Ensure .html.erb files are detected as erb filetype for TailwindCSS
vim.filetype.add({
  extension = {
    ['html.erb'] = 'erb',
  },
})