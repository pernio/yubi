param(
    [string]$Command = "help",
    [string]$Argument
)

$YubiKeys = @{
    "terry" = "x"
    "jerry" = "y"
}

function Show-Usage {
@"
Usage:
  .\yubi.ps1 edit
  .\yubi.ps1 status
  .\yubi.ps1 restart
  .\yubi.ps1 current
  .\yubi.ps1 test
  .\yubi.ps1 list
  .\yubi.ps1 switch <name>
  .\yubi.ps1 enable
  .\yubi.ps1 disable
  .\yubi.ps1 help

Examples:
  .\yubi.ps1 switch terry
  .\yubi.ps1 switch jerry
"@
}

function Get-CurrentKey {
    git config --global --get user.signingkey 2>$null
}

function Set-Key {
    param([string]$KeyId)

    git config --global user.signingkey $KeyId
    gpgconf --kill gpg-agent
}

function Get-KeyNameForId {
    param([string]$KeyId)

    foreach ($name in $YubiKeys.Keys) {
        if ($YubiKeys[$name] -eq $KeyId) {
            return $name
        }
    }

    return "unknown"
}

function Show-Keys {
    Write-Host "Configured YubiKeys:"
    foreach ($name in $YubiKeys.Keys) {
        Write-Host "  $name -> $($YubiKeys[$name])"
    }
}

function Show-Current {
    $key = Get-CurrentKey

    if ([string]::IsNullOrWhiteSpace($key)) {
        Write-Host "No global Git signing key is set."
        return
    }

    Write-Host "Current Git signing key: $key"
    Write-Host "Alias: $(Get-KeyNameForId $key)"
}

function Test-Sign {
    "test" | gpg --clearsign | Out-Null
    Write-Host "GPG signing worked."
}

function Switch-Key {
    param([string]$Name)

    if ([string]::IsNullOrWhiteSpace($Name)) {
        Write-Host "Usage: .\yubi.ps1 switch <name>"
        Show-Keys
        exit 1
    }

    if (-not $YubiKeys.ContainsKey($Name)) {
        Write-Host "Unknown YubiKey name: $Name"
        Show-Keys
        exit 1
    }

    Set-Key $YubiKeys[$Name]
    Write-Host "Switched to $Name ($($YubiKeys[$Name]))"
}

switch ($Command) {
    "edit" {
        gpg --card-edit
    }
    "restart" {
        gpgconf --kill gpg-agent
        Write-Host "gpg-agent restarted."
    }
    "status" {
        gpg --card-status
    }
    "current" {
        Show-Current
    }
    "test" {
        Test-Sign
    }
    "list" {
        Show-Keys
    }
    "switch" {
        Switch-Key $Argument
    }
    "enable" {
        git config --global commit.gpgsign true
        Write-Host "Yubi Git commit signing enabled."
    }
    "disable" {
        git config --global commit.gpgsign false
        Write-Host "Yubi Git commit signing disabled."
    }
    "help" {
        Show-Usage
    }
    default {
        Show-Usage
        exit 1
    }
}
