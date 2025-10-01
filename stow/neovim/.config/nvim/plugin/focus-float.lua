-- focus floating window
local function focus_floating_window()
  local floating_wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      table.insert(floating_wins, win)
    end
  end
  
  if #floating_wins == 0 then
    vim.notify("No floating windows found", vim.log.levels.INFO)
    return
  end
  
  -- Find the first floating window that's not the current one
  local current_win = vim.api.nvim_get_current_win()
  for _, win in ipairs(floating_wins) do
    if win ~= current_win then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  
  -- If all floating windows are current, focus the first one
  vim.api.nvim_set_current_win(floating_wins[1])
end

vim.api.nvim_create_user_command('FocusFloatingWindow', focus_floating_window, {})
