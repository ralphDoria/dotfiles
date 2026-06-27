# Symlinks nvim\ into %LOCALAPPDATA%\nvim on Windows.
# Requires Developer Mode (Settings > Privacy & security > For developers)
# or an elevated/admin PowerShell to create symlinks.
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Source = Join-Path $ScriptDir "nvim"
$Target = Join-Path $env:LOCALAPPDATA "nvim"

if (Test-Path $Target) {
    $item = Get-Item $Target -Force
    if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        Write-Host "Backing up existing $Target -> $Target.bak"
        Move-Item $Target "$Target.bak"
    } else {
        Remove-Item $Target -Force
    }
}

New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
Write-Host "Linked $Source -> $Target"
