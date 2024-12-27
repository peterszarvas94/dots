-- go to treesitter context
local function go_to_treesitter_context()
  require('treesitter-context').go_to_context(vim.v.count1)
end

vim.api.nvim_create_user_command('TSGoToContext', go_to_treesitter_context, {})
