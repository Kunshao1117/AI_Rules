param(
    [Parameter(Mandatory = $true)]
    [string]$HookEvent
)

$ErrorActionPreference = 'Stop'

$allowedEvents = @('SessionStart', 'UserPromptSubmit', 'PreToolUse')

function Write-LauncherDirective {
    param(
        [string]$EventName,
        [string]$SystemMessage,
        [string]$AdditionalContext
    )

    [ordered]@{
        systemMessage = $SystemMessage
        hookSpecificOutput = [ordered]@{
            hookEventName = $EventName
            additionalContext = $AdditionalContext
        }
    } | ConvertTo-Json -Depth 8 -Compress
}

try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    if ($allowedEvents -notcontains $HookEvent) {
        Write-LauncherDirective `
            -EventName $HookEvent `
            -SystemMessage ('Codex Team-Native hook event is outside the active directive set: {0}' -f $HookEvent) `
            -AdditionalContext 'Supported Team-Native hook events: SessionStart, UserPromptSubmit, PreToolUse. NON_IGNORABLE_DIRECTIVE=true.'
        exit 0
    }

    $raw = [Console]::In.ReadToEnd()
    if (-not $raw -and $env:AI_RULES_HOOK_STDIN) {
        $raw = $env:AI_RULES_HOOK_STDIN
    }

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
        Write-LauncherDirective `
            -EventName $HookEvent `
            -SystemMessage 'Codex Team-Native hook directive script was not found' `
            -AdditionalContext 'Codex Team-Native hook directive script was not found; treat Team-Native route as unverified until restored.'
    }
} catch {
    Write-LauncherDirective `
        -EventName $HookEvent `
        -SystemMessage 'Codex Team-Native hook launcher exception' `
        -AdditionalContext ('Codex Team-Native hook launcher exception; treat Team-Native route as unverified until fixed. ' + $_.Exception.Message)
}

exit 0
