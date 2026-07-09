-- ~/.config/nvim/lua/config/autocmds.lua
--
-- Auto-reload buffers when files change on disk from outside Neovim
-- (e.g. OpenCode / Claude editing files while a session is open).
--
-- Drop-in for lazy.nvim / LazyVim. LazyVim auto-loads this path.
-- On plain lazy.nvim, require it from your init.lua:  require("config.autocmds")
--
-- WSL note: keep projects on the Linux filesystem (~/projects), NOT /mnt/c.
-- inotify events don't cross the drvfs boundary, so the polling timer below
-- is what makes external-edit detection reliable on WSL.

-- autoread only reloads buffers with NO unsaved changes. If you've edited a
-- buffer and the file also changed on disk, Neovim prompts instead of clobbering
-- your work -- which is the behavior you want.
vim.opt.autoread = true

-- CursorHold fires after this many ms of inactivity. Lower = snappier reloads.
vim.opt.updatetime = 1000

-- Only run :checktime when it's actually safe (not in command-line mode,
-- not in the command-line window, and only for real files).
local function safe_checktime()
  if vim.fn.mode() == "c" then return end
  if vim.fn.getcmdwintype() ~= "" then return end
  if vim.bo.buftype ~= "" then return end -- skip terminals, help, prompts, etc.
  vim.cmd("checktime")
end

local group = vim.api.nvim_create_augroup("user_autoreload", { clear = true })

-- Event-driven checks: cover focus changes, buffer switches, and idle cursor.
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" },
  {
    group = group,
    callback = safe_checktime,
  }
)

-- Polling fallback -- essential on WSL, where focus/inotify events are unreliable.
-- Checks every second while you're sitting in normal mode.
local timer = vim.uv.new_timer()
timer:start(
  1000,
  1000,
  vim.schedule_wrap(function()
    if vim.fn.mode() == "n" then
      safe_checktime()
    end
  end)
)

-- Notify when a buffer actually gets reloaded, so a silent external edit
-- doesn't surprise you later.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function()
    vim.notify("Buffer reloaded from disk (changed externally)", vim.log.levels.WARN)
  end,
})
