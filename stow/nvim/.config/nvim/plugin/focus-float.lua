-- focus floating window
local function focus_floating_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end

vim.api.nvim_create_user_command('FocusFloatingWindow', focus_floating_window, {})
