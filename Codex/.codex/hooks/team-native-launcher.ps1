param(
    [Parameter(Mandatory = $true)]
    [string]$HookEvent
)

$ErrorActionPreference = 'Stop'

function Write-LauncherAdvisory {
    param(
        [string]$SystemMessage,
        [string]$AdditionalContext
    )

    [ordered]@{
        systemMessage = $SystemMessage
        hookSpecificOutput = [ordered]@{
            hookEventName = $HookEvent
            additionalContext = $AdditionalContext
        }
    } | ConvertTo-Json -Depth 8 -Compress
}

try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    $raw = [Console]::In.ReadToEnd()
    $payload = $null
    try {
        if (-not [string]::IsNullOrWhiteSpace($raw)) {
            $payload = $raw | ConvertFrom-Json -ErrorAction Stop
        }
    } catch {
        $payload = $null
    }

    $start = $null
    if ($null -ne $payload -and $payload.PSObject.Properties['cwd']) {
        $start = [string]$payload.PSObject.Properties['cwd'].Value
    }
    if ([string]::IsNullOrWhiteSpace($start)) {
        $start = (Get-Location).Path
    }

    try {
        $dir = (Resolve-Path -LiteralPath $start -ErrorAction Stop).Path
    } catch {
        $dir = (Get-Location).Path
    }
    if (Test-Path -LiteralPath $dir -PathType Leaf) {
        $dir = Split-Path -Parent $dir
    }

    $scriptPath = $null
    while (-not [string]::IsNullOrWhiteSpace($dir)) {
        $candidate = Join-Path $dir '.codex/hooks/team-native-gate.ps1'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            $scriptPath = $candidate
            break
        }

        $parent = Split-Path -Parent $dir
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $dir) {
            break
        }
        $dir = $parent
    }

    if ($scriptPath) {
        & $scriptPath -HookEvent $HookEvent -PayloadJson $raw
    } else {
        Write-LauncherAdvisory -SystemMessage 'Codex hook script was not found' -AdditionalContext 'Codex hook script was not found; advisory/reminder only.'
    }
} catch {
    $message = 'Codex hook launcher exception; advisory/reminder only. ' + $_.Exception.Message
    Write-LauncherAdvisory -SystemMessage 'Codex hook launcher exception' -AdditionalContext $message
}

exit 0
