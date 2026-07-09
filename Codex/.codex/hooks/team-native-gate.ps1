param(
    [string]$HookEvent,
    [string]$PayloadJson
)

$ErrorActionPreference = 'Stop'

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom

function Get-HookPropertyValue {
    param([object]$Object, [string[]]$Names)
    if ($null -eq $Object) { return $null }
    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties[$name]
        if ($null -ne $property) { return $property.Value }
    }
    return $null
}

function Write-HookReminder {
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

function Write-SessionStartReminder {
    Write-HookReminder `
        -EventName 'SessionStart' `
        -SystemMessage '團隊模式提醒：目前以 captain-led Team-Native 路線運作。隊長只負責協調、派站、接收交付與彙整；不得把啟動提醒當成授權或完成證據。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=SessionStart',
            'TEAM_NATIVE_ACTIVE=true',
            'CAPTAIN_ROLE=coordination_only',
            'CAPTAIN_ALLOWED=coordination, station dispatch, artifact receipt, synthesis, named-file local probe',
            'CAPTAIN_FORBIDDEN=broad read, validation, review, memory-docs attribution, completion evidence, protected mutation',
            'REMINDER_ONLY=true'
        ) -join "`n")
}

function Write-UserPromptSubmitReminder {
    Write-HookReminder `
        -EventName 'UserPromptSubmit' `
        -SystemMessage '本輪團隊模式提醒：隊長不得直接取代隊員做廣泛讀取、驗證、審查、記憶文件、完成證據或受保護操作。若隊長要自做，必須由操作者明確解除團隊模式並授權具體範圍。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=UserPromptSubmit',
            'TEAM_NATIVE_ACTIVE=true',
            'CAPTAIN_DIRECT_WORK=forbidden_for_broad_read_validation_review_memory_docs_completion_evidence',
            'CAPTAIN_EXCEPTION_REQUIRES=operator_explicitly_disables_team_mode_and_authorizes_concrete_scope',
            'NEXT_LEGAL_ACTION=dispatch_matching_station_or_report_noncomplete_state',
            'REMINDER_ONLY=true'
        ) -join "`n")
}

function Write-PreToolUseReminder {
    Write-HookReminder `
        -EventName 'PreToolUse' `
        -SystemMessage '工具前置強提醒：這個 hook 只提示、不阻擋工具。隊長不得用工具直接取代隊員完成廣泛讀取、驗證、審查、記憶文件或完成證據；若要自做，需先由操作者明確解除團隊模式並授權具體範圍。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=PreToolUse',
            'PRETOOL_GUARD=advisory_only',
            'NO_DENY_OR_BLOCK=true',
            'CAPTAIN_FORBIDDEN=broad read, validation, review, memory-docs attribution, completion evidence',
            'CAPTAIN_EXCEPTION_REQUIRES=operator_explicitly_disables_team_mode_and_authorizes_concrete_scope'
        ) -join "`n")
}

function Write-UnsupportedEventReminder {
    param([string]$EventName)
    if ([string]::IsNullOrWhiteSpace($EventName)) { $EventName = 'Unknown' }
    Write-HookReminder `
        -EventName $EventName `
        -SystemMessage ('Team-Native hook event is not managed by this simplified Codex gate: {0}.' -f $EventName) `
        -AdditionalContext (@(
            ('AI_RULES_HOOK_EVENT={0}' -f $EventName),
            'SUPPORTED_EVENTS=SessionStart,UserPromptSubmit,PreToolUse',
            'REMINDER_ONLY=true'
        ) -join "`n")
}

if ($PSBoundParameters.ContainsKey('PayloadJson')) {
    $rawInput = $PayloadJson
} else {
    $rawInput = [Console]::In.ReadToEnd()
}
if (-not $rawInput -and $env:AI_RULES_HOOK_STDIN) {
    $rawInput = $env:AI_RULES_HOOK_STDIN
}

$payload = $null
try {
    if (-not [string]::IsNullOrWhiteSpace($rawInput)) {
        $payload = $rawInput | ConvertFrom-Json -ErrorAction Stop
    }
} catch {
    $payload = $null
}

$eventName = $HookEvent
if ([string]::IsNullOrWhiteSpace($eventName)) {
    $eventName = [string](Get-HookPropertyValue -Object $payload -Names @('hook_event_name','event','hook_event','codex_hook_event'))
}

switch ($eventName) {
    'SessionStart' { Write-SessionStartReminder }
    'UserPromptSubmit' { Write-UserPromptSubmitReminder }
    'PreToolUse' { Write-PreToolUseReminder }
    default { Write-UnsupportedEventReminder -EventName $eventName }
}

exit 0
