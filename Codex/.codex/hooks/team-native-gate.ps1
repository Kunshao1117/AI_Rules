[CmdletBinding()]
param(
    [string]$Event
)

$ErrorActionPreference = 'Stop'

function Read-HookInputText {
    try {
        return [Console]::In.ReadToEnd()
    } catch {
        return ''
    }
}

function ConvertFrom-HookJson {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return [PSCustomObject]@{ __parse_error = 'empty input' }
    }

    try {
        return ($Text | ConvertFrom-Json -ErrorAction Stop)
    } catch {
        return [PSCustomObject]@{ __parse_error = $_.Exception.Message }
    }
}

function Get-HookDebugMarkerPath {
    return (Join-Path $env:TEMP 'ai-rules-codex-hook-debug.enable')
}

function Test-HookDebugEnabled {
    $markerPath = Get-HookDebugMarkerPath
    return (Test-Path -LiteralPath $markerPath -PathType Leaf)
}

function Write-HookDebugSnapshot {
    param(
        [string]$EventName,
        [string]$InputText,
        [object]$Payload
    )

    if (-not (Test-HookDebugEnabled)) { return }

    try {
        $debugRoot = Join-Path $env:TEMP 'ai-rules-codex-hook-debug'
        if (-not (Test-Path -LiteralPath $debugRoot -PathType Container)) {
            $null = New-Item -ItemType Directory -Force -Path $debugRoot
        }

        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
        $safeEvent = if ($EventName) { $EventName -replace '[^A-Za-z0-9_.-]', '_' } else { 'Unknown' }
        $path = Join-Path $debugRoot ("{0}-{1}-{2}.json" -f $stamp, $PID, $safeEvent)
        $inputSample = $InputText
        if ($inputSample -and $inputSample.Length -gt 60000) {
            $inputSample = $inputSample.Substring(0, 60000)
        }

        $topLevelKeys = @()
        if ($null -ne $Payload) {
            $topLevelKeys = @($Payload.PSObject.Properties | ForEach-Object { $_.Name })
        }

        $snapshot = [PSCustomObject]@{
            timestamp    = (Get-Date).ToString('o')
            event        = $EventName
            process_id   = $PID
            top_keys     = $topLevelKeys
            hook_event   = Get-HookProperty -Object $Payload -Name 'hook_event_name'
            tool_name    = Get-HookProperty -Object $Payload -Name 'tool_name'
            tool         = Get-HookProperty -Object $Payload -Name 'tool'
            matcher_hint = Get-HookProperty -Object $Payload -Name 'matcher'
            input_sample = $inputSample
        }

        $snapshot | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $path -Encoding UTF8
    } catch {
        return
    }
}

function Get-HookProperty {
    param(
        [object]$Object,
        [string]$Name
    )

    if ($null -eq $Object) { return $null }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
}

function Get-StringLeafValues {
    param([object]$Value)

    $items = New-Object System.Collections.Generic.List[string]

    if ($null -eq $Value) {
        return @()
    }

    if ($Value -is [string]) {
        if ($Value.Length -gt 0) { $items.Add($Value) }
        return @($items.ToArray())
    }

    if ($Value -is [System.Management.Automation.PSCustomObject]) {
        foreach ($property in $Value.PSObject.Properties) {
            foreach ($item in @(Get-StringLeafValues -Value $property.Value)) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($key in $Value.Keys) {
            foreach ($item in @(Get-StringLeafValues -Value $Value[$key])) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($entry in $Value) {
            foreach ($item in @(Get-StringLeafValues -Value $entry)) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    $items.Add([string]$Value)
    return @($items.ToArray())
}

function Get-NamedStringLeafValues {
    param(
        [object]$Value,
        [string]$Prefix
    )

    $items = New-Object System.Collections.Generic.List[string]

    if ($null -eq $Value) {
        return @()
    }

    if ($Value -is [string]) {
        if ($Value.Length -gt 0) {
            $items.Add(("{0}: {1}" -f $Prefix, $Value))
        }
        return @($items.ToArray())
    }

    if ($Value -is [System.Management.Automation.PSCustomObject]) {
        foreach ($property in $Value.PSObject.Properties) {
            $childPrefix = if ($Prefix) { "{0}.{1}" -f $Prefix, $property.Name } else { $property.Name }
            foreach ($item in @(Get-NamedStringLeafValues -Value $property.Value -Prefix $childPrefix)) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($key in $Value.Keys) {
            $childPrefix = if ($Prefix) { "{0}.{1}" -f $Prefix, $key } else { [string]$key }
            foreach ($item in @(Get-NamedStringLeafValues -Value $Value[$key] -Prefix $childPrefix)) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($entry in $Value) {
            foreach ($item in @(Get-NamedStringLeafValues -Value $entry -Prefix $Prefix)) {
                $items.Add($item)
            }
        }
        return @($items.ToArray())
    }

    $items.Add(("{0}: {1}" -f $Prefix, ([string]$Value)))
    return @($items.ToArray())
}

function Get-TranscriptContext {
    param([object]$Payload)

    $path = Get-HookProperty -Object $Payload -Name 'transcript_path'
    if (-not $path) { return '' }
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return '' }

    try {
        $content = Get-Content -LiteralPath $path -Raw -Encoding UTF8 -ErrorAction Stop
    } catch {
        return ''
    }

    $maxChars = 200000
    if ($content.Length -le $maxChars) { return $content }
    return $content.Substring($content.Length - $maxChars)
}

function Get-HistoricalTranscriptReferenceText {
    param([object]$Payload)

    $items = New-Object System.Collections.Generic.List[string]
    $transcriptText = Get-TranscriptContext -Payload $Payload
    if ($transcriptText) {
        $items.Add($transcriptText)
    }

    foreach ($field in @('transcript', 'conversation_history', 'history', 'messages')) {
        $value = Get-HookProperty -Object $Payload -Name $field
        if ($null -eq $value) { continue }
        foreach ($item in @(Get-StringLeafValues -Value $value)) {
            $items.Add($item)
        }
    }

    return (@($items.ToArray()) -join "`n")
}

function Get-CurrentStructuredEvidenceText {
    param([object]$Payload)

    $trusted = New-Object System.Collections.Generic.List[string]

    $trustedFields = @(
        'team_native_trace',
        'team_native_evidence',
        'authorization_evidence',
        'authorization_scope',
        'authorization_target',
        'authorized_action',
        'authorized_files',
        'protected_authorization',
        'captain_team_board',
        'team_board',
        'board',
        'station',
        'handoff',
        'role',
        'channel',
        'completion_state',
        'delivery_artifacts',
        'implementation_delivery',
        'change_delivery',
        'memory_delivery',
        'memory_docs_delivery',
        'review_delivery',
        'validation_delivery',
        'direct_exceptions',
        'metadata'
    )

    foreach ($field in $trustedFields) {
        $value = Get-HookProperty -Object $Payload -Name $field
        if ($null -eq $value) { continue }
        foreach ($item in @(Get-NamedStringLeafValues -Value $value -Prefix $field)) {
            $trusted.Add($item)
        }
    }

    return (@($trusted.ToArray()) -join "`n")
}

function Get-HookActionText {
    param([object]$Payload)

    $items = New-Object System.Collections.Generic.List[string]
    foreach ($field in @(
        'hook_event_name',
        'tool_name',
        'tool',
        'matcher',
        'permission_mode',
        'tool_input',
        'input',
        'arguments',
        'params',
        'prompt',
        'user_prompt',
        'request',
        'message',
        'response',
        'output',
        'content'
    )) {
        $value = Get-HookProperty -Object $Payload -Name $field
        if ($null -eq $value) { continue }
        foreach ($item in @(Get-StringLeafValues -Value $value)) {
            $items.Add($item)
        }
    }
    return (@($items.ToArray()) -join "`n")
}

function Write-HookJson {
    param([hashtable]$Object)

    $Object | ConvertTo-Json -Depth 20 -Compress | Write-Output
}

function Exit-AllowWithContext {
    param(
        [string]$EventName,
        [string]$Message
    )

    Write-HookJson @{
        hookSpecificOutput = @{
            hookEventName     = $EventName
            additionalContext = $Message
        }
    }
    exit 0
}

function Exit-AllowWithSystemMessage {
    param([string]$Message)

    Write-HookJson @{
        systemMessage = $Message
    }
    exit 0
}

function Exit-Block {
    param(
        [string]$EventName,
        [string]$Reason
    )

    switch ($EventName) {
        'PreToolUse' {
            Write-HookJson @{
                hookSpecificOutput = @{
                    hookEventName            = 'PreToolUse'
                    permissionDecision       = 'deny'
                    permissionDecisionReason = $Reason
                }
            }
            exit 0
        }
        'PermissionRequest' {
            Write-HookJson @{
                hookSpecificOutput = @{
                    hookEventName = 'PermissionRequest'
                    decision      = @{
                        behavior = 'deny'
                        message  = $Reason
                    }
                }
            }
            exit 0
        }
        'Stop' {
            Write-HookJson @{
                decision = 'block'
                reason   = $Reason
            }
            exit 0
        }
        'SubagentStop' {
            Write-HookJson @{
                decision = 'block'
                reason   = $Reason
            }
            exit 0
        }
        default {
            [Console]::Error.WriteLine($Reason)
            exit 2
        }
    }
}

function Test-HasTeamNativeEvidence {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $hasBoard = $Text -match '(?i)(Captain Team Board|Team-Native trace|formal-write|formal-readonly)'
    $hasStation = $Text -match '(?i)(station_id|applicable station|formal station|Captain Team Board)'
    $hasHandoff = $Text -match '(?i)(handoff_packet_id|station handoff|team-station-handoff-packet)'
    $hasRoleId = $Text -match '(?i)\brole_id\b'
    $hasRoleInstance = $Text -match '(?i)\brole_instance_id\b'
    $hasSkill = $Text -match '(?i)(assigned specialist skill|specialist skill|team-specialist-)'
    $hasRequestedChannel = $Text -match '(?i)\brequested_execution_channel\b'
    $hasChannelCapability = $Text -match '(?i)\bchannel_capability\b'
    $hasChannelStatus = $Text -match '(?i)\bchannel_invocation_status\b'

    return ($hasBoard -and $hasStation -and $hasHandoff -and $hasRoleId -and $hasRoleInstance -and $hasSkill -and $hasRequestedChannel -and $hasChannelCapability -and $hasChannelStatus)
}

function Test-IsWriteToolName {
    param([string]$ToolName)

    if ([string]::IsNullOrWhiteSpace($ToolName)) { return $false }
    return $ToolName -match '(?i)(apply_patch|edit|multi.?edit|write|delete|move|copy|create|update|notebook.?edit|mcp__.*(create|update|delete|write|deploy|push|apply|mutation))'
}

function Test-IsProtectedMutationToolName {
    param([string]$ToolName)

    if ([string]::IsNullOrWhiteSpace($ToolName)) { return $false }
    return $ToolName -match '(?i)(request_plugin_install|memory_commit|cartridge-system__memory_commit|mcp__.*(deploy|push|publish|release|mutation)|deploy|release|publish)'
}

function Test-HasProtectedMutation {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $patterns = @(
        '(?i)\bgit\s+(?:add|apply|commit|push|tag|reset|checkout|restore|clean|merge|rebase)\b',
        '(?i)\bgh\s+(?:release|pr\s+merge)\b',
        '(?i)\b(?:npm|pnpm)\s+publish\b',
        '(?i)\byarn\s+npm\s+publish\b',
        '(?i)\b(?:npm|pnpm|yarn|bun)\s+(?:install|i|add|remove|rm|uninstall|update|upgrade)\b',
        '(?i)\b(?:pip|pip3)\s+install\b',
        '(?i)\b(?:python|python3|py)\s+-m\s+pip\s+install\b',
        '(?i)\buv\s+(?:add|remove)\b',
        '(?i)\buv\s+pip\s+install\b',
        '(?i)\bpoetry\s+(?:add|remove|install)\b',
        '(?i)\bcargo\s+(?:add|install)\b',
        '(?i)\bgo\s+get\b',
        '(?i)\bdotnet\s+add\s+(?:[^\s]+\s+)?package\b',
        '(?i)\bDeploy\.ps1\b',
        '(?i)\binstall\.ps1\b',
        '(?i)\bmemory_commit\b',
        '(?i)\bcartridge-system__memory_commit\b',
        '(?i)\brequest_plugin_install\b',
        '(?i)\brm\s+-rf\b'
    )

    foreach ($pattern in $patterns) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Get-HookProtectedMutationKeys {
    param([string]$Text)

    $keys = New-Object System.Collections.Generic.List[string]
    if ([string]::IsNullOrWhiteSpace($Text)) { return @() }

    $specs = @(
        @{ Pattern = '(?i)\bgit\s+apply\b'; Key = 'git apply' },
        @{ Pattern = '(?i)\bgit\s+checkout\b'; Key = 'git checkout' },
        @{ Pattern = '(?i)\bgit\s+restore\b'; Key = 'git restore' },
        @{ Pattern = '(?i)\bgit\s+reset\b'; Key = 'git reset' },
        @{ Pattern = '(?i)\bgit\s+clean\b'; Key = 'git clean' },
        @{ Pattern = '(?i)\bgit\s+add\b'; Key = 'git add' },
        @{ Pattern = '(?i)\bgit\s+commit\b'; Key = 'git commit' },
        @{ Pattern = '(?i)\bgit\s+push\b'; Key = 'git push' },
        @{ Pattern = '(?i)\bgit\s+tag\b'; Key = 'git tag' },
        @{ Pattern = '(?i)\b(?:npm|pnpm|yarn|bun)\s+(?:install|i)\b'; Key = 'npm install' },
        @{ Pattern = '(?i)\b(?:npm|pnpm|yarn|bun)\s+add\b'; Key = 'npm add' },
        @{ Pattern = '(?i)\b(?:npm|pnpm|yarn|bun)\s+(?:remove|rm|uninstall)\b'; Key = 'npm remove' },
        @{ Pattern = '(?i)\b(?:npm|pnpm|yarn|bun)\s+(?:update|upgrade)\b'; Key = 'npm update' },
        @{ Pattern = '(?i)\b(?:pip|pip3|python|python3|py)\b.{0,40}\bpip\s+install\b|\b(?:pip|pip3)\s+install\b'; Key = 'pip install' },
        @{ Pattern = '(?i)\buv\s+add\b'; Key = 'uv add' },
        @{ Pattern = '(?i)\buv\s+remove\b'; Key = 'uv remove' },
        @{ Pattern = '(?i)\buv\s+pip\s+install\b'; Key = 'uv pip install' },
        @{ Pattern = '(?i)\bpoetry\s+add\b'; Key = 'poetry add' },
        @{ Pattern = '(?i)\bpoetry\s+remove\b'; Key = 'poetry remove' },
        @{ Pattern = '(?i)\bpoetry\s+install\b'; Key = 'poetry install' },
        @{ Pattern = '(?i)\bcargo\s+add\b'; Key = 'cargo add' },
        @{ Pattern = '(?i)\bcargo\s+install\b'; Key = 'cargo install' },
        @{ Pattern = '(?i)\bgo\s+get\b'; Key = 'go get' },
        @{ Pattern = '(?i)\bdotnet\s+add\s+(?:[^\s]+\s+)?package\b'; Key = 'dotnet add package' },
        @{ Pattern = '(?i)\bmemory_commit\b|\bcartridge-system__memory_commit\b'; Key = 'memory_commit' },
        @{ Pattern = '(?i)\brequest_plugin_install\b'; Key = 'request_plugin_install' },
        @{ Pattern = '(?i)\bDeploy\.ps1\b|(?m)^\s*(?:mcp__\S*(?:deploy)\S*|deploy)\s*$'; Key = 'deploy' },
        @{ Pattern = '(?i)\bgh\s+release\b|(?m)^\s*(?:mcp__\S*(?:release)\S*|release)\s*$'; Key = 'release' },
        @{ Pattern = '(?i)\b(?:npm|pnpm)\s+publish\b|\byarn\s+npm\s+publish\b|(?m)^\s*(?:mcp__\S*(?:publish)\S*|publish)\s*$'; Key = 'publish' }
    )

    foreach ($spec in $specs) {
        if ($Text -match $spec.Pattern) {
            $keys.Add($spec.Key)
        }
    }

    return @($keys.ToArray() | Select-Object -Unique)
}

function Test-IsIgnoredShellWriteTarget {
    param([string]$Target)

    if ([string]::IsNullOrWhiteSpace($Target)) { return $true }
    $clean = $Target.Trim().Trim('"', "'").ToLowerInvariant()
    return ($clean -match '^(&\d|\$null|nul|/dev/null|null)$')
}

function Test-HasShellWriteSignal {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }

    $writePatterns = @(
        '(?i)\b(?:Set-Content|Add-Content|Out-File|New-Item|Remove-Item|Move-Item|Copy-Item|Rename-Item)\b',
        '(?i)\btee\b(?:\s+-(?:a|-append|i))*\s+["'']?[^"''\s|;&]+["'']?',
        '(?i)\bsed\b[^\r\n]*\s-i(?:\s|$)',
        '(?i)\bperl\b[^\r\n]*\s-pi(?:\s|$)',
        '(?i)\bopen\s*\(\s*["''][^"'']+["'']\s*,\s*["''][^"'']*[wax+][^"'']*["'']',
        '(?i)\bPath\s*\(\s*["''][^"'']+["'']\s*\)\.write_(?:text|bytes)\s*\(',
        '(?i)\b(?:fs\.)?(?:writeFileSync|writeFile|appendFileSync|appendFile)\s*\(',
        '(?i)\bFile\.write\s*\(',
        '(?i)\bfile_put_contents\s*\(',
        '(?i)\[IO\.File\]::Write(?:AllText|AllBytes|AllLines)\s*\('
    )
    foreach ($pattern in $writePatterns) {
        if ($Text -match $pattern) { return $true }
    }

    $redirectPattern = '(?m)(?:^|[\s|;&])(?:\d?>{1,2}|>{1,2})\s*(?!&\d)(["'']?)([^"''\s|;&]+)\1'
    foreach ($match in [regex]::Matches($Text, $redirectPattern)) {
        if (-not (Test-IsIgnoredShellWriteTarget -Target $match.Groups[2].Value)) {
            return $true
        }
    }

    return $false
}

function Test-HasReadOnlyCommand {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    if (Test-HasProtectedMutation -Text $Text) { return $false }
    if (Test-HasShellWriteSignal -Text $Text) { return $false }
    return $Text -match '(?i)(\brg\b|\bgrep\b|\bfindstr\b|\bSelect-String\b|\bGet-Content\b|\bGet-ChildItem\b|\bGet-FileHash\b|\bTest-Path\b|\bResolve-Path\b|\bgit\s+(status|diff|show|log|ls-files|rev-parse|branch|remote|ls-remote|grep)\b)'
}

function Test-HasBroadReadCommand {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    if (Test-HasProtectedMutation -Text $Text) { return $false }
    if (Test-HasShellWriteSignal -Text $Text) { return $false }
    return $Text -match '(?i)(\brg\s+--files\b|\bgit\s+grep\b|\bGet-ChildItem\b.{0,160}\b-Recurse\b|\bSelect-String\b.{0,160}\b-Recurse\b|\bGet-Content\b.{0,120}(\*|-Recurse)\b|\bfind\s+\.\b)'
}

function Get-HookToolBehavior {
    param(
        [string]$ToolName,
        [string]$ActionText
    )

    if ((Test-IsProtectedMutationToolName -ToolName $ToolName) -or (Test-HasProtectedMutation -Text $ActionText)) {
        return 'protected-mutation'
    }
    if ((Test-IsWriteToolName -ToolName $ToolName) -or (Test-HasShellWriteSignal -Text $ActionText)) {
        return 'write-capable'
    }
    if (Test-HasBroadReadCommand -Text $ActionText) {
        return 'broad-read'
    }
    if (Test-HasReadOnlyCommand -Text $ActionText) {
        return 'read-only'
    }
    return 'unknown'
}

function Test-HasSpecialistDeepReadEvidence {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $hasDeepReadScope = $Text -match '(?i)(deep_read_scope|specialist deep-read|assigned files|evidence artifact)'
    $hasSpecialistRole = $Text -match '(?i)(\brole_id\b.{0,120}(intent-requirements|scope-impact|external-research|architecture-contract|change-delivery|validation|review|security-reliability|memory-docs|release-completion|team-specialist-)|assigned specialist skill.{0,80}team-specialist-)'
    $hasHandoff = $Text -match '(?i)(handoff_packet_id|station handoff|team-station-handoff-packet)'
    return ($hasDeepReadScope -and $hasSpecialistRole -and $hasHandoff)
}

function Get-HookRecordFieldValue {
    param(
        [object]$Record,
        [string[]]$Names
    )

    if ($null -eq $Record) { return '' }

    foreach ($name in $Names) {
        $value = $null
        if ($Record -is [System.Collections.IDictionary]) {
            if ($Record.Contains($name)) {
                $value = $Record[$name]
            }
        } else {
            $property = $Record.PSObject.Properties[$name]
            if ($null -ne $property) {
                $value = $property.Value
            }
        }

        if ($null -eq $value) { continue }
        $text = (@(Get-StringLeafValues -Value $value) -join ' ').Trim()
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            return $text
        }
    }

    return ''
}

function Get-HookProtectedAuthorizationRecords {
    param([object]$Payload)

    $records = New-Object System.Collections.Generic.List[object]
    $value = Get-HookProperty -Object $Payload -Name 'protected_authorization'
    if ($null -eq $value) { return @() }

    if ($value -is [string]) { return @() }
    if ($value -is [System.Collections.IDictionary]) {
        $records.Add($value)
        return @($records.ToArray())
    }
    if ($value -is [System.Management.Automation.PSCustomObject]) {
        $records.Add($value)
        return @($records.ToArray())
    }
    if ($value -is [System.Collections.IEnumerable]) {
        foreach ($entry in $value) {
            if (($entry -is [System.Collections.IDictionary]) -or ($entry -is [System.Management.Automation.PSCustomObject])) {
                $records.Add($entry)
            }
        }
    }

    return @($records.ToArray())
}

function Test-HookTextContainsLiteral {
    param(
        [string]$Text,
        [string]$Needle
    )

    if ([string]::IsNullOrWhiteSpace($Text) -or [string]::IsNullOrWhiteSpace($Needle)) { return $false }
    return ($Text.ToLowerInvariant().IndexOf($Needle.ToLowerInvariant(), [StringComparison]::Ordinal) -ge 0)
}

function Get-HookProtectedActionDetailTokens {
    param(
        [string]$ActionPhrase,
        [string]$Key
    )

    $tokens = New-Object System.Collections.Generic.List[string]
    if ([string]::IsNullOrWhiteSpace($ActionPhrase)) { return @() }

    $phrase = $ActionPhrase.Trim()
    if ($phrase -match '^\s*[\w.-]+(?:\.[\w.-]+)*\s*:\s*(.+?)\s*$') {
        $phrase = $matches[1].Trim()
    }

    $keyParts = @($Key.ToLowerInvariant() -split '\s+' | Where-Object { $_ })
    $ignore = @(
        'command',
        'tool_input',
        'tool',
        'bash',
        'powershell',
        'pwsh',
        'cmd',
        'git',
        'npm',
        'pnpm',
        'yarn',
        'bun',
        'pip',
        'pip3',
        'python',
        'python3',
        'py'
    ) + $keyParts

    foreach ($match in [regex]::Matches($phrase, '[A-Za-z0-9_.:/\\-]+')) {
        $token = $match.Value.Trim().Trim('"', "'", ',', ';')
        if ([string]::IsNullOrWhiteSpace($token)) { continue }
        $lower = $token.ToLowerInvariant()
        if ($lower.StartsWith('-')) { continue }
        if ($ignore -contains $lower) { continue }
        if ($lower.Length -lt 2) { continue }
        $tokens.Add($token)
    }

    return @($tokens.ToArray() | Select-Object -Unique)
}

function Get-HookProtectedActionRequirements {
    param(
        [string]$ActionText
    )

    $requirements = New-Object System.Collections.Generic.List[object]
    $requestedKeys = @(Get-HookProtectedMutationKeys -Text $ActionText)
    foreach ($key in $requestedKeys) {
        $phrases = New-Object System.Collections.Generic.List[string]
        foreach ($line in @($ActionText -split "`r?`n")) {
            if (Test-HookTextContainsLiteral -Text $line -Needle $key) {
                $phrases.Add($line.Trim())
            }
        }
        if ($phrases.Count -eq 0) {
            $phrases.Add($key)
        }

        foreach ($phrase in @($phrases.ToArray() | Select-Object -Unique)) {
            $requirements.Add([PSCustomObject]@{
                Key          = $key
                Phrase       = $phrase
                DetailTokens = @(Get-HookProtectedActionDetailTokens -ActionPhrase $phrase -Key $key)
            })
        }
    }

    return @($requirements.ToArray())
}

function Test-HookProtectedAuthorizationRecordMatchesAction {
    param(
        [object]$Record,
        [object]$ActionRequirement
    )

    $requiredFields = @(
        'authorization_source',
        'authorization_target',
        'authorization_scope',
        'authorization_phase',
        'authorization_evidence',
        'authorization_expiry',
        'authorization_resolution_state'
    )

    foreach ($field in $requiredFields) {
        if ([string]::IsNullOrWhiteSpace((Get-HookRecordFieldValue -Record $Record -Names @($field)))) {
            return $false
        }
    }

    $resolutionValue = Get-HookRecordFieldValue -Record $Record -Names @('authorization_resolution_state')
    $hasPositiveResolution = $false
    if ($resolutionValue -notmatch '(?i)\b(unscoped|missing|none|unknown|expired|stale|partial|draft|implicit|open-ended|unbounded|pending|not\s+authorized)\b' -and
        $resolutionValue -match '(?i)\b(scoped|current|explicit|approved|authorized)\b') {
        $hasPositiveResolution = $true
    }
    if (-not $hasPositiveResolution) { return $false }

    $expiryValue = Get-HookRecordFieldValue -Record $Record -Names @('authorization_expiry')
    $hasCurrentExpiry = $false
    if ($expiryValue -notmatch '(?i)\b(expired|stale|missing|none|unknown|open-ended|unbounded|permanent|indefinite)\b' -and
        $expiryValue -match '(?i)\b(current\s+(task|phase|turn)|this\s+(task|phase|turn)|explicit\s+scope|scoped\s+to|current-task|current-phase|task\s+only|phase\s+only)\b') {
        $hasCurrentExpiry = $true
    }
    if (-not $hasCurrentExpiry) { return $false }

    $authorizedAction = Get-HookRecordFieldValue -Record $Record -Names @(
        'authorized_action',
        'authorized_action_key',
        'authorization_action',
        'action_key',
        'protected_action',
        'protected_action_key'
    )
    if ([string]::IsNullOrWhiteSpace($authorizedAction)) { return $false }

    $targetScope = @(
        (Get-HookRecordFieldValue -Record $Record -Names @('authorization_target')),
        (Get-HookRecordFieldValue -Record $Record -Names @('authorization_scope'))
    ) -join ' '
    if ([string]::IsNullOrWhiteSpace($targetScope)) { return $false }

    $key = [string]$ActionRequirement.Key
    if ([string]::IsNullOrWhiteSpace($key)) { return $false }
    if (-not (Test-HookTextContainsLiteral -Text $authorizedAction -Needle $key)) {
        return $false
    }
    if (-not (Test-HookTextContainsLiteral -Text $targetScope -Needle $key)) {
        return $false
    }

    $detailTokens = @($ActionRequirement.DetailTokens)
    if ($detailTokens.Count -eq 0) {
        return $true
    }

    foreach ($token in $detailTokens) {
        if (Test-HookTextContainsLiteral -Text $targetScope -Needle $token) {
            return $true
        }
    }

    return $false
}

function Test-HasProtectedAuthorizationEvidence {
    param(
        [string]$ActionText,
        [string]$EvidenceText,
        [object]$Payload
    )

    $requirements = @(Get-HookProtectedActionRequirements -ActionText $ActionText)
    if ($requirements.Count -eq 0) { return $false }

    $records = @(Get-HookProtectedAuthorizationRecords -Payload $Payload)
    if ($records.Count -eq 0) { return $false }

    foreach ($requirement in $requirements) {
        $isCovered = $false
        foreach ($record in $records) {
            if (Test-HookProtectedAuthorizationRecordMatchesAction -Record $record -ActionRequirement $requirement) {
                $isCovered = $true
                break
            }
        }
        if (-not $isCovered) {
            return $false
        }
    }

    return $true
}

function Convert-HookPathToken {
    param(
        [string]$Path,
        [string]$RepoRoot
    )

    if ([string]::IsNullOrWhiteSpace($Path)) { return '' }
    $clean = $Path.Trim()
    $clean = $clean.Trim('"', "'", '`')
    $clean = $clean.TrimEnd('.', ',', ';', ':')
    if (-not [string]::IsNullOrWhiteSpace($RepoRoot)) {
        try {
            $repoFull = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\', '/')
            $candidate = $clean -replace '/', '\'
            $candidateFull = if ([IO.Path]::IsPathRooted($candidate)) {
                [IO.Path]::GetFullPath($candidate)
            } else {
                [IO.Path]::GetFullPath((Join-Path $repoFull $candidate))
            }

            if ($candidateFull.Equals($repoFull, [StringComparison]::OrdinalIgnoreCase)) {
                return ''
            }
            $repoPrefix = $repoFull + [IO.Path]::DirectorySeparatorChar
            if ($candidateFull.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
                $clean = $candidateFull.Substring($repoPrefix.Length)
            } elseif ([IO.Path]::IsPathRooted($candidate)) {
                $clean = $candidateFull
            }
        } catch {
        }
    }
    $clean = $clean -replace '^[.][\\/]', ''
    $clean = $clean -replace '\\', '/'
    $clean = $clean -replace '/+', '/'
    return $clean.ToLowerInvariant()
}

function Get-HookExplicitAuthorizedWritePaths {
    param(
        [string]$EvidenceText,
        [string]$RepoRoot
    )

    $paths = New-Object System.Collections.Generic.List[string]
    if ([string]::IsNullOrWhiteSpace($EvidenceText)) { return @() }

    $pathPattern = '(?i)(?:[A-Za-z]:)?(?:\.{1,2}[\\/])?(?:[A-Za-z0-9_. -]+[\\/])+[A-Za-z0-9_. -]+|(?<![\w.-])[A-Za-z0-9_.-]+\.[A-Za-z0-9][A-Za-z0-9._-]*(?![\w.-])'
    foreach ($line in @($EvidenceText -split "`r?`n")) {
        $match = [regex]::Match($line, '(?i)^\s*(?:authorized_files?|authorization_target|target_files?|write_scope|file_scope)(?:[.\w\[\]-]*)?\s*:\s*(.+?)\s*$')
        if (-not $match.Success) { continue }

        $value = $match.Groups[1].Value
        foreach ($pathMatch in [regex]::Matches($value, $pathPattern)) {
            $path = Convert-HookPathToken -Path $pathMatch.Value -RepoRoot $RepoRoot
            if ($path) { $paths.Add($path) }
        }
    }

    return @($paths.ToArray() | Select-Object -Unique)
}

function Test-HookNormalizedPathEqual {
    param(
        [string]$Left,
        [string]$Right,
        [string]$RepoRoot
    )

    if ([string]::IsNullOrWhiteSpace($Left) -or [string]::IsNullOrWhiteSpace($Right)) { return $false }
    $leftPath = Convert-HookPathToken -Path $Left -RepoRoot $RepoRoot
    $rightPath = Convert-HookPathToken -Path $Right -RepoRoot $RepoRoot
    return ($leftPath -and $rightPath -and ($leftPath -eq $rightPath))
}

function Get-HookActionTargetPaths {
    param(
        [string]$Text,
        [string]$RepoRoot
    )

    $targets = New-Object System.Collections.Generic.List[string]
    if ([string]::IsNullOrWhiteSpace($Text)) { return @() }

    foreach ($line in @($Text -split "`r?`n")) {
        $match = [regex]::Match($line, '^\s*\*\*\*\s+(?:Add|Update|Delete)\s+File:\s+(.+?)\s*$')
        if ($match.Success) {
            $target = Convert-HookPathToken -Path $match.Groups[1].Value -RepoRoot $RepoRoot
            if ($target) { $targets.Add($target) }
            continue
        }

        $moveMatch = [regex]::Match($line, '^\s*\*\*\*\s+Move\s+to:\s+(.+?)\s*$')
        if ($moveMatch.Success) {
            $target = Convert-HookPathToken -Path $moveMatch.Groups[1].Value -RepoRoot $RepoRoot
            if ($target) { $targets.Add($target) }
        }
    }

    $commandPatterns = @(
        '(?i)\b(?:Set-Content|Add-Content|Out-File|New-Item|Remove-Item|Move-Item|Copy-Item|Rename-Item)\b[^\r\n]*?\s-(?:LiteralPath|Path|FilePath|Destination)\s+["'']?([^"''`\r\n]+?)["'']?(?:\s|$)',
        '(?m)(?:^|[\s|;&])(?:\d?>{1,2}|>{1,2})\s*(?!&\d)(["'']?)([^"''`\s\r\n|;&]+)\1',
        '(?i)\btee\b(?:\s+-(?:a|-append|i))*\s+(["'']?)([^"''`\s\r\n|;&]+)\1',
        '(?i)\bopen\s*\(\s*["'']([^"'']+)["'']\s*,\s*["''][^"'']*[wax+][^"'']*["'']',
        '(?i)\bPath\s*\(\s*["'']([^"'']+)["'']\s*\)\.write_(?:text|bytes)\s*\(',
        '(?i)\b(?:fs\.)?(?:writeFileSync|writeFile|appendFileSync|appendFile)\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\bFile\.write\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\bfile_put_contents\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\[IO\.File\]::Write(?:AllText|AllBytes|AllLines)\s*\(\s*["'']([^"'']+)["'']'
    )
    foreach ($pattern in $commandPatterns) {
        foreach ($match in [regex]::Matches($Text, $pattern)) {
            $targetValue = $match.Groups[$match.Groups.Count - 1].Value
            if (Test-IsIgnoredShellWriteTarget -Target $targetValue) { continue }
            $target = Convert-HookPathToken -Path $targetValue -RepoRoot $RepoRoot
            if ($target) { $targets.Add($target) }
        }
    }

    return @($targets.ToArray() | Select-Object -Unique)
}

function Test-HasScopedWriteAuthorization {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $hasAuthorization = $Text -match '(?i)(authorization_evidence|scoped authorization|authorization_scope|Director GO|authorized_action|authorized_files)'
    $hasScope = $Text -match '(?i)(authorization_scope|authorization_target|authorized_action|authorized_files|exclusive_task_scope)'
    return ($hasAuthorization -and $hasScope)
}

function Test-ActionWithinScopedWriteAuthorization {
    param(
        [string]$ActionText,
        [string]$EvidenceText,
        [string]$RepoRoot
    )

    if (-not (Test-HasScopedWriteAuthorization -Text $EvidenceText)) { return $false }
    $targets = @(Get-HookActionTargetPaths -Text $ActionText -RepoRoot $RepoRoot)
    if ($targets.Count -eq 0) { return $false }
    $authorizedPaths = @(Get-HookExplicitAuthorizedWritePaths -EvidenceText $EvidenceText -RepoRoot $RepoRoot)
    if ($authorizedPaths.Count -eq 0) { return $false }

    foreach ($target in $targets) {
        $matched = $false
        foreach ($authorizedPath in $authorizedPaths) {
            if (Test-HookNormalizedPathEqual -Left $target -Right $authorizedPath -RepoRoot $RepoRoot) {
                $matched = $true
                break
            }
        }
        if (-not $matched) {
            return $false
        }
    }
    return $true
}

function Test-IsGovernancePrompt {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    return $Text -match '(?i)(GO\b|Wave\s+\d+|implementation|fix|build|audit|Doctor|commit|push|release|deploy|memory|hook|Team-Native|subagent|workflow|governance)'
}

function Test-IsCurrentCompletionReferenceLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $true }
    $trimmed = $Line.Trim()
    if ($trimmed -match '^(>|`{3}|//|#)') { return $true }
    return $trimmed -match '(?i)(fixture|test string|test text|expectedOutputRegex|forbiddenOutputRegex|regex|pattern|example|sample|quote|quoted|literal|引用|測試|說明文字|說明|範例)'
}

function Test-ClaimsCompletion {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $completionPatterns = @(
        'full team completion',
        'implementation complete',
        'validation passed',
        'Doctor/Audit passed',
        'ready to commit',
        'ready for commit',
        '\b(?:all\s+)?(?:tests?|checks?|fixtures?)\s+(?:passed|complete|completed)\b',
        '\b(?:Wave\s+\d+|Team-Native|implementation|validation|Doctor/Audit|repair|fix|build|change|task|work|hook)\b.{0,120}\b(?:complete|completed|done|passed|ready)\b',
        ('\bDoctor\b.{0,80}' + (New-UnicodeString -Codes @(0x901A, 0x904E))),
        ((New-UnicodeString -Codes @(0x5DF2, 0x5B8C, 0x6210)) + '.{0,80}\bDoctor\b.{0,80}' + (New-UnicodeString -Codes @(0x901A, 0x904E))),
        '^\s*(?:complete|completed|done|passed)\s*[.!]?\s*$',
        'Wave\s+\d+.{0,80}(complete|completed|done|passed|ready)',
        '\b(?:this|current|the)\s+(?:turn|task|work|implementation|fix|change)\s+is\s+(?:complete|completed|done|ready)\b',
        (New-UnicodeString -Codes @(0x672C, 0x8F2A, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x4FEE, 0x5FA9, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x8B8A, 0x66F4, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x9A57, 0x8B49, 0x901A, 0x904E)),
        (New-UnicodeString -Codes @(0x6E2C, 0x8A66, 0x901A, 0x904E)),
        (New-UnicodeString -Codes @(0x53EF, 0x63D0, 0x4EA4))
    )

    foreach ($line in @($Text -split "`r?`n")) {
        if (Test-IsCurrentCompletionReferenceLine -Line $line) { continue }
        foreach ($pattern in $completionPatterns) {
            if ($line -match ('(?i)' + $pattern)) { return $true }
        }
    }
    return $false
}

function Test-IsNegatedArtifactLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    if ($Line -match '(?i)\b(no|not|missing|without|lacks?|lack|absent|none|unavailable)\b') { return $true }

    $zhNegations = @(
        (New-UnicodeString -Codes @(0x7F3A, 0x5C11)),
        (New-UnicodeString -Codes @(0x5C1A, 0x7F3A)),
        (New-UnicodeString -Codes @(0x6C92, 0x6709)),
        (New-UnicodeString -Codes @(0x672A, 0x63D0, 0x4F9B)),
        (New-UnicodeString -Codes @(0x672A, 0x56DE, 0x6536)),
        (New-UnicodeString -Codes @(0x672A, 0x8FD4, 0x56DE)),
        (New-UnicodeString -Codes @(0x7121))
    )
    foreach ($term in $zhNegations) {
        if ($Line.Contains($term)) { return $true }
    }
    return $false
}

function Test-IsNegatedClosureStateLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    if ($Line -match '(?i)\b(?:completion_state|review_state|validation_state|memory_docs_state|memory_delivery_state|review_delivery_state|validation_delivery_state|blocker_status|status|state)\s*[:=]\s*(?:blocked|unverified|partial-evidence|closed-with-director-risk|not-complete|incomplete)\b') {
        return $false
    }
    $negatedBeforeState = $Line -match '(?i)\b(?:not|no|without|missing|lacks?|lack|absent)\b.{0,80}\b(?:blocked|unverified|closed-with-director-risk)\b'
    $negatedAfterState = $Line -match '(?i)\b(?:blocked|unverified|closed-with-director-risk)\b.{0,80}\b(?:false|no|not)\b'
    $zhNegations = @(
        (New-UnicodeString -Codes @(0x4E0D, 0x662F)),
        (New-UnicodeString -Codes @(0x975E)),
        (New-UnicodeString -Codes @(0x6C92, 0x6709)),
        (New-UnicodeString -Codes @(0x7121))
    )
    $zhStates = @(
        (New-UnicodeString -Codes @(0x963B, 0x585E)),
        (New-UnicodeString -Codes @(0x672A, 0x9A57, 0x8B49)),
        (New-UnicodeString -Codes @(0x98A8, 0x96AA, 0x95DC, 0x9589))
    )
    $negatedZhState = $false
    foreach ($negation in $zhNegations) {
        if (-not $Line.Contains($negation)) { continue }
        foreach ($state in $zhStates) {
            if ($Line.Contains($state)) {
                $negatedZhState = $true
                break
            }
        }
        if ($negatedZhState) { break }
    }
    return ($negatedBeforeState -or $negatedAfterState -or $negatedZhState)
}

function Test-HasPositiveArtifactMention {
    param(
        [string]$Text,
        [string]$ArtifactPattern
    )

    $positiveStatePattern = '(?i)(returned|present|provided|ready|complete|completed|validated|passed|available|recovered|delivered|\bwith\b)'
    $positiveZhTerms = @(
        (New-UnicodeString -Codes @(0x5177, 0x5099)),
        (New-UnicodeString -Codes @(0x5DF2, 0x63D0, 0x4F9B)),
        (New-UnicodeString -Codes @(0x5DF2, 0x56DE, 0x6536)),
        (New-UnicodeString -Codes @(0x5DF2, 0x8FD4, 0x56DE)),
        (New-UnicodeString -Codes @(0x4EA4, 0x4ED8, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x901A, 0x904E)),
        (New-UnicodeString -Codes @(0x9F4A, 0x5099)),
        (New-UnicodeString -Codes @(0x5B58, 0x5728))
    )
    foreach ($line in @($Text -split "`r?`n")) {
        if (Test-IsCurrentCompletionReferenceLine -Line $line) { continue }
        if (Test-IsNegatedArtifactLine -Line $line) { continue }
        $hasPositiveZh = $false
        foreach ($term in $positiveZhTerms) {
            if ($line.Contains($term)) {
                $hasPositiveZh = $true
                break
            }
        }
        if (($line -match $ArtifactPattern) -and (($line -match $positiveStatePattern) -or $hasPositiveZh)) {
            return $true
        }
    }
    return $false
}

function Test-HasFullArtifactSet {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $required = @(
        '(?i)(implementation change delivery|change delivery)',
        '(?i)(memory/docs delivery|memory delivery|memory-docs delivery|docs delivery|memory_delivery)',
        '(?i)(review delivery)',
        '(?i)(validation delivery)'
    )

    foreach ($pattern in $required) {
        if (-not (Test-HasPositiveArtifactMention -Text $Text -ArtifactPattern $pattern)) { return $false }
    }
    return $true
}

function Test-HasNonCompleteClosureState {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $englishPattern = '(?i)\b(?:completion_state|review_state|validation_state|memory_docs_state|memory_delivery_state|review_delivery_state|validation_delivery_state|blocker_status|status|state)\s*[:=]\s*(?:blocked|unverified|partial-evidence|closed-with-director-risk|not-complete|incomplete)\b'
    $zhStateKeys = @(
        (New-UnicodeString -Codes @(0x5B8C, 0x6210, 0x72C0, 0x614B)),
        (New-UnicodeString -Codes @(0x6536, 0x5C3E, 0x72C0, 0x614B)),
        (New-UnicodeString -Codes @(0x9A57, 0x8B49, 0x72C0, 0x614B)),
        (New-UnicodeString -Codes @(0x5BE9, 0x67E5, 0x72C0, 0x614B)),
        (New-UnicodeString -Codes @(0x8A18, 0x61B6, 0x6587, 0x4EF6, 0x72C0, 0x614B)),
        (New-UnicodeString -Codes @(0x662F, 0x5426, 0x963B, 0x585E))
    )
    $zhStates = @(
        (New-UnicodeString -Codes @(0x963B, 0x585E)),
        (New-UnicodeString -Codes @(0x672A, 0x9A57, 0x8B49)),
        (New-UnicodeString -Codes @(0x90E8, 0x5206, 0x8B49, 0x64DA)),
        (New-UnicodeString -Codes @(0x98A8, 0x96AA, 0x95DC, 0x9589)),
        (New-UnicodeString -Codes @(0x5C1A, 0x672A, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x672A, 0x5B8C, 0x6210))
    )

    foreach ($line in @($Text -split "`r?`n")) {
        if (Test-IsCurrentCompletionReferenceLine -Line $line) { continue }
        if (Test-IsNegatedClosureStateLine -Line $line) { continue }
        $hasZhKey = $false
        foreach ($key in $zhStateKeys) {
            if ($line.Contains($key)) {
                $hasZhKey = $true
                break
            }
        }
        $hasZhState = $false
        foreach ($state in $zhStates) {
            if ($line.Contains($state)) {
                $hasZhState = $true
                break
            }
        }
        if (($line -match $englishPattern) -or ($hasZhKey -and $hasZhState)) {
            return $true
        }
    }
    return $false
}

function New-UnicodeString {
    param([int[]]$Codes)

    $chars = New-Object System.Collections.Generic.List[char]
    foreach ($code in $Codes) {
        $chars.Add([char]$code)
    }
    return (-join $chars.ToArray())
}

function Test-HasSpecialistReportFormat {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $english = ($Text -match '(?i)(finding|findings)') -and
        ($Text -match '(?i)evidence') -and
        ($Text -match '(?i)risk') -and
        ($Text -match '(?i)(recommendation|recommendations|suggestion|suggestions)') -and
        ($Text -match '(?i)(blocking|blocker|blocked)')
    if ($english) { return $true }

    $zhLabels = @(
        (New-UnicodeString -Codes @(0x767C, 0x73FE)),
        (New-UnicodeString -Codes @(0x8B49, 0x64DA)),
        (New-UnicodeString -Codes @(0x98A8, 0x96AA)),
        (New-UnicodeString -Codes @(0x5EFA, 0x8B70)),
        (New-UnicodeString -Codes @(0x662F, 0x5426, 0x963B, 0x585E))
    )
    foreach ($label in $zhLabels) {
        if ($Text -notmatch [regex]::Escape($label)) { return $false }
    }
    return $true
}

$inputText = Read-HookInputText
$payload = ConvertFrom-HookJson -Text $inputText
$eventName = $Event
if (-not $eventName) {
    $eventName = Get-HookProperty -Object $payload -Name 'hook_event_name'
}
if (-not $eventName) { $eventName = 'Unknown' }

Write-HookDebugSnapshot -EventName $eventName -InputText $inputText -Payload $payload

$parseError = Get-HookProperty -Object $payload -Name '__parse_error'
if ($parseError) {
    Exit-AllowWithSystemMessage -Message ("Team-Native hook input was not valid JSON; hook evidence is unverified: {0}" -f $parseError)
}

$actionText = Get-HookActionText -Payload $payload
$evidenceText = Get-CurrentStructuredEvidenceText -Payload $payload
$transcriptText = Get-HistoricalTranscriptReferenceText -Payload $payload
$currentText = ($actionText + "`n" + $evidenceText).Trim()
$diagnosticText = ($currentText + "`n" + $transcriptText).Trim()
$toolName = Get-HookProperty -Object $payload -Name 'tool_name'
if (-not $toolName) {
    $toolName = Get-HookProperty -Object $payload -Name 'tool'
}

if ($actionText -match '--dangerously-bypass-hook-trust') {
    Exit-Block -EventName $eventName -Reason 'Codex hook trust bypass is forbidden by the Team-Native guard.'
}

$permissionMode = Get-HookProperty -Object $payload -Name 'permission_mode'
$repoRoot = Get-HookProperty -Object $payload -Name 'cwd'
$toolBehavior = Get-HookToolBehavior -ToolName $toolName -ActionText $actionText
$hasTeamNativeEvidence = Test-HasTeamNativeEvidence -Text $evidenceText
$hasProtectedMutation = ($toolBehavior -eq 'protected-mutation')
$hasWriteCapableAction = ($toolBehavior -eq 'write-capable')
$hasReadOnlyCommand = (($toolBehavior -eq 'read-only') -or ($toolBehavior -eq 'broad-read'))
$hasBroadReadCommand = ($toolBehavior -eq 'broad-read')
$hasSpecialistDeepReadEvidence = Test-HasSpecialistDeepReadEvidence -Text $evidenceText
$hasProtectedAuthorizationEvidence = Test-HasProtectedAuthorizationEvidence -ActionText $actionText -EvidenceText $evidenceText -Payload $payload
$hasScopedWriteAuthorization = Test-HasScopedWriteAuthorization -Text $evidenceText
$hasActionWithinScopedWriteAuthorization = Test-ActionWithinScopedWriteAuthorization -ActionText $actionText -EvidenceText $evidenceText -RepoRoot $repoRoot

switch ($eventName) {
    'UserPromptSubmit' {
        if ((Test-IsGovernancePrompt -Text $actionText) -and (-not $hasTeamNativeEvidence)) {
            Exit-AllowWithContext -EventName 'UserPromptSubmit' -Message 'Team-Native route hint: governance-impact, coding, validation, review, memory, commit, release, and broad file work require a Captain Team Board, station handoff, role identity, channel state, and recovered delivery artifacts before completion claims.'
        }
    }
    'PreToolUse' {
        if ($hasWriteCapableAction -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Write-capable tool requested before a complete Team-Native board, handoff, role identity, and channel state are visible.'
        }
        if ($hasWriteCapableAction -and (-not $hasActionWithinScopedWriteAuthorization)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Write-capable tool requires scoped write authorization evidence that matches every current target path.'
        }
        if ($hasProtectedMutation -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Protected mutation requested before Team-Native board or channel evidence is visible. Open or recover the formal station evidence first.'
        }
        if (($permissionMode -eq 'bypassPermissions') -and $hasProtectedMutation -and (-not $hasProtectedAuthorizationEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Protected mutation under bypass permission mode is not allowed without explicit Team-Native closure evidence.'
        }
        if ($hasProtectedMutation -and (-not $hasProtectedAuthorizationEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Protected mutation requires explicit protected authorization evidence for the current phase, target, and closure state.'
        }
        if ($hasReadOnlyCommand -and $hasBroadReadCommand -and (-not $hasTeamNativeEvidence)) {
            Exit-AllowWithContext -EventName 'PreToolUse' -Message 'Captain-Lite read model: broad read is allowed as read-only evidence, but it should be routed to a formal-readonly specialist deep-read station before completion claims.'
        }
        if ($hasReadOnlyCommand -and $hasBroadReadCommand -and $hasTeamNativeEvidence -and (-not $hasSpecialistDeepReadEvidence)) {
            Exit-AllowWithContext -EventName 'PreToolUse' -Message 'Captain-Lite read model: board evidence is visible, but broad reads should name deep_read_scope and specialist deep-read ownership before they become completion evidence.'
        }
    }
    'PermissionRequest' {
        if ($hasWriteCapableAction -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Write-capable tool permission request lacks a complete Team-Native board, handoff, role identity, and channel state.'
        }
        if ($hasWriteCapableAction -and (-not $hasActionWithinScopedWriteAuthorization)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Write-capable permission request requires scoped write authorization evidence that matches every current target path.'
        }
        if ($hasProtectedMutation -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Permission request lacks visible Team-Native board, role, channel, and authorization evidence for the protected mutation.'
        }
        if ($hasProtectedMutation -and (-not $hasProtectedAuthorizationEvidence)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Protected mutation permission requires explicit protected authorization evidence for the current phase, target, and closure state.'
        }
    }
    'SubagentStart' {
        Exit-AllowWithContext -EventName 'SubagentStart' -Message 'Team-Native specialist report must include findings, evidence, risks, recommendations, and blocking status. Specialist branches must not mutate source, memory, git, release, deploy, or external state unless explicitly assigned as an isolated change-delivery branch.'
    }
    'SubagentStop' {
        $stopActive = Get-HookProperty -Object $payload -Name 'stop_hook_active'
        if (($stopActive -ne $true) -and (-not (Test-HasSpecialistReportFormat -Text $currentText))) {
            Exit-AllowWithContext -EventName 'SubagentStop' -Message 'Specialist output should include findings, evidence, risks, recommendations, and blocking status before the captain accepts it as Team-Native evidence.'
        }
    }
    'Stop' {
        $stopActive = Get-HookProperty -Object $payload -Name 'stop_hook_active'
        if (($stopActive -ne $true) -and (Test-ClaimsCompletion -Text $actionText) -and (-not (Test-HasFullArtifactSet -Text $currentText)) -and (-not (Test-HasNonCompleteClosureState -Text $currentText))) {
            Exit-Block -EventName 'Stop' -Reason 'Completion claim requires recovered implementation, review, and validation delivery artifacts or an explicit blocked/unverified/closed-with-director-risk state.'
        }
    }
}

exit 0
