-- Clipboard for sessions whose yanks may need to reach another machine:
-- every copy is emitted as OSC 52 (inside tmux/herdr this can rebroadcast to
-- every attached client, local or SSH). Paste prefers the local Wayland
-- clipboard when one is available, so content copied in other apps remains
-- pasteable; without a display, paste is an OSC 52 query that the terminal
-- answers.
local M = {}

local function proc_lines(pid, file)
  local ok, lines = pcall(vim.fn.readfile, "/proc/" .. pid .. "/" .. file)
  return ok and lines or {}
end

local function proc_ppid(pid)
  for _, line in ipairs(proc_lines(pid, "status")) do
    local ppid = line:match("^PPid:%s+(%d+)")
    if ppid then
      return tonumber(ppid)
    end
  end
end

local function ancestor_process_named(name)
  local pid = vim.fn.getpid()

  for _ = 1, 16 do
    local ppid = proc_ppid(pid)
    if not ppid or ppid <= 1 then
      return false
    end

    local comm = proc_lines(ppid, "comm")[1] or ""
    if comm:find(name, 1, true) then
      return true
    end

    local cmdline = table.concat(proc_lines(ppid, "cmdline"), "\0")
    if cmdline:find(name, 1, true) then
      return true
    end

    pid = ppid
  end

  return false
end

local function yank_lines(regname)
  local name = regname == "" and '"' or regname
  local lines = vim.fn.getreg(name, 1, true)
  if type(lines) == "string" then
    return lines == "" and {} or { lines }
  end
  return lines
end

local function wrap_paste(paste_fn)
  return function()
    local result = paste_fn()
    if type(result) ~= "table" then
      return {}
    end
    return result
  end
end

local function sync_clipboard_option()
  if vim.fn.has("clipboard") ~= 1 then
    return
  end

  -- LazyVim clears clipboard during startup and restores it on VeryLazy; run
  -- after that so normal `y` uses the + register (system clipboard).
  vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
  end)
end

local function setup_ssh_osc52_yank(osc52)
  if not osc52 or vim.g.omarchy_remote_clipboard_osc52 == false then
    return
  end

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("OmarchyRemoteClipboard", { clear = true }),
    callback = function(ev)
      local lines = yank_lines(ev.regname)
      if #lines == 0 then
        return
      end
      osc52.copy("+")(lines)
    end,
  })
end

function M.setup()
  local in_tmux = vim.env.TMUX ~= nil
  local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
  local in_herdr = vim.env.HERDR_PANE_ID ~= nil or ancestor_process_named("herdr")
  local use_osc52 = in_tmux or in_ssh or in_herdr

  -- WAYLAND_DISPLAY is often still set over SSH; wl-paste then fails and
  -- unnamedplus paste hits an empty + register (E353).
  local has_wayland = not in_ssh
    and vim.env.WAYLAND_DISPLAY ~= nil
    and vim.fn.executable("wl-copy") == 1
    and vim.fn.executable("wl-paste") == 1

  if not (use_osc52 or has_wayland) then
    return
  end

  if in_ssh then
    -- Keep LazyVim's clipboard="" so `y`/`p` use the unnamed register inside
    -- nvim. Neovim can still opt into OSC 52 when clipboard stays empty.
    setup_ssh_osc52_yank(require("vim.ui.clipboard.osc52"))
    return
  end

  local osc52 = use_osc52 and require("vim.ui.clipboard.osc52") or nil

  local function copy(register)
    local emit = osc52 and osc52.copy(register)

    return function(lines)
      if has_wayland then
        local cmd = { "wl-copy", "--sensitive", "--type", "text/plain" }
        if register == "*" then
          cmd[#cmd + 1] = "--primary"
        end
        vim.fn.system(cmd, lines)
      end

      if emit and vim.g.omarchy_remote_clipboard_osc52 ~= false then
        emit(lines)
      end
    end
  end

  local function paste(register)
    if not has_wayland then
      return wrap_paste(osc52.paste(register))
    end

    return function()
      local cmd = { "wl-paste", "--no-newline" }
      if register == "*" then
        cmd[#cmd + 1] = "--primary"
      end

      local lines = vim.fn.systemlist(cmd, "", 1)
      return vim.v.shell_error == 0 and lines or {}
    end
  end

  vim.g.clipboard = {
    name = "OmarchyRemoteClipboard",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = wrap_paste(paste("+")), ["*"] = wrap_paste(paste("*")) },
    cache_enabled = 0,
  }

  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = sync_clipboard_option,
  })
end

return M
