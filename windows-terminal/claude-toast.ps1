param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Stop', 'Notification')]
    [string]$Event
)

# Toast notifier for Claude Code (called from WSL hooks via powershell.exe).
# Reads the hook's JSON payload from stdin so we can surface useful detail.

$ErrorActionPreference = 'SilentlyContinue'

# Pull the hook payload piped on stdin (may be empty for some events).
$raw = [Console]::In.ReadToEnd()
$payload = $null
if ($raw) { try { $payload = $raw | ConvertFrom-Json } catch {} }

Import-Module BurntToast -ErrorAction SilentlyContinue

switch ($Event) {
    'Notification' {
        $title = 'Claude Code - needs you'
        $body  = if ($payload.message) { [string]$payload.message } else { 'Claude is waiting for your input.' }
        $sound = 'ms-winsoundevent:Notification.Reminder'
        # Reminder scenario keeps the banner on screen until you act on it.
        $scenario = 'Reminder'
    }
    'Stop' {
        $title = 'Claude Code - finished'
        $body  = 'Claude finished responding.'
        $sound = 'ms-winsoundevent:Notification.Default'
        # Default scenario; Long duration keeps it up ~25s instead of ~5s.
        $scenario = 'Default'
    }
}

$text1   = New-BTText -Content $title
$text2   = New-BTText -Content $body
$binding = New-BTBinding -Children $text1, $text2
$visual  = New-BTVisual -BindingGeneric $binding
$audio   = New-BTAudio -Source $sound
$dismiss = New-BTButton -Dismiss
$actions = New-BTAction -Buttons $dismiss

if ($scenario -eq 'Reminder') {
    $content = New-BTContent -Visual $visual -Audio $audio -Actions $actions -Scenario Reminder
} else {
    $content = New-BTContent -Visual $visual -Audio $audio -Duration Long
}

Submit-BTNotification -Content $content
