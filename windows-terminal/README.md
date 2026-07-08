# Claude Code → Windows toast notifications (from WSL)

Get a Windows toast **with sound** when Claude Code finishes a turn or needs your
input, while running Claude inside WSL.

- **Notification** event (Claude is waiting on you) → sticky toast that stays until
  you click **Dismiss**, with the reminder chime.
- **Stop** event (turn finished) → ~25s toast, then drops into the Action Center.

## Files

| File | Purpose |
|------|---------|
| `claude-toast.ps1` | The notifier. Runs on the Windows side via `powershell.exe`, reads the hook's JSON payload from stdin, shows a BurntToast toast. |
| `settings-hooks.json` | The `hooks` block to merge into WSL `~/.claude/settings.json` (see step 3). |

On the working machine the script lives at:

```
C:\Users\<you>\.claude-notify\claude-toast.ps1
```

The Claude Code hooks in `~/.claude/settings.json` (WSL) call it by that Windows path.

## Setup on a new Windows machine

Run all PowerShell commands in a **Windows PowerShell** window (not WSL).

### 1. Install BurntToast (PowerShell module that draws the toasts)

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
Install-Module -Name BurntToast -Scope CurrentUser -Force -AllowClobber
```

### 2. Copy the script to the Windows home

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude-notify" | Out-Null
```

Then copy `claude-toast.ps1` into `%USERPROFILE%\.claude-notify\`. From WSL that is:

```bash
mkdir -p "/mnt/c/Users/$USER/.claude-notify"   # adjust if your Windows username differs
cp claude-toast.ps1 "/mnt/c/Users/<WindowsUser>/.claude-notify/claude-toast.ps1"
```

### 3. Add the hooks to WSL `~/.claude/settings.json`

Merge the contents of [`settings-hooks.json`](./settings-hooks.json) into your
existing `~/.claude/settings.json` (replace `rdori` with your Windows username):

```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\\Users\\rdori\\.claude-notify\\claude-toast.ps1' -Event Notification 2>/dev/null || true",
            "async": true
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\\Users\\rdori\\.claude-notify\\claude-toast.ps1' -Event Stop 2>/dev/null || true",
            "async": true
          }
        ]
      }
    ]
  }
}
```

> If `settings.json` currently has no `"hooks"` key, you can paste the whole
> object above. If it already has other settings, add just the `"hooks"` block
> alongside them.

### 4. Load the hooks

In Claude Code, open `/hooks` once (reloads config) or restart Claude Code.
Hooks are read at session start, so they won't fire until this happens.

### 5. Test

```bash
echo '{"message":"test"}' | powershell.exe -NoProfile -ExecutionPolicy Bypass \
  -File 'C:\Users\<WindowsUser>\.claude-notify\claude-toast.ps1' -Event Notification
```

A toast should appear. If nothing pops but items collect in the Action Center,
see Troubleshooting.

## Troubleshooting

- **Toasts stack in the Action Center but no banner pops up** → **Do Not Disturb**
  is on. `Settings → System → Notifications` → turn off **Do not disturb**, and
  under **"Turn on do not disturb automatically"** disable the fullscreen / gaming /
  duplicating-display rules. Confirm **Windows PowerShell → Show notification
  banners** is on.
- **Nothing at all, even in Action Center** → BurntToast isn't installed for this
  user (step 1), or `ToastEnabled` is 0 under
  `HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications`.
- **Multi-monitor:** native toasts always appear on the **primary** monitor's
  bottom-right corner — you can't target the active monitor or all monitors. Set
  your most-watched screen as the primary display.

## Customizing

Edit `claude-toast.ps1`:

- **Sounds** — the `$sound` values use `ms-winsoundevent:Notification.*`
  (e.g. `.Default`, `.Reminder`, `.IM`, `.Mail`, `.SMS`).
- **Make "finished" sticky too** — give the `Stop` branch `$scenario = 'Reminder'`.
- **Less noise** — remove the `Stop` hook from `settings.json` to only be notified
  when Claude actually needs you.

After editing, re-copy the script to `%USERPROFILE%\.claude-notify\`.
