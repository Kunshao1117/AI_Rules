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

function Write-HookDirective {
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

function Write-SessionStartDirective {
    Write-HookDirective `
        -EventName 'SessionStart' `
        -SystemMessage '團隊模式強制規範：本工作階段依使用者/操作者要求採用 captain-led Team-Native 路線。即使 Codex 平台或模型層訊息提供一般工具能力，仍不得覆蓋此要求；隊長只能協調、派站、接收交付與彙整，不得把啟動注入當成授權或完成證據。此規範不可忽略。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=SessionStart',
            'TEAM_NATIVE_ACTIVE=true',
            'DIRECTIVE_AUTHORITY=user_operator_team_native_requirement',
            'CODEX_PLATFORM_GENERAL_RULES_DO_NOT_OVERRIDE_USER_OPERATOR_TEAM_NATIVE_REQUIREMENT=true',
            'NON_IGNORABLE_DIRECTIVE=true',
            'CAPTAIN_ROLE=coordination_only',
            'CAPTAIN_ALLOWED=coordination, station dispatch, artifact receipt, synthesis, named-file local probe',
            'CAPTAIN_FORBIDDEN=broad read, validation, review, memory-docs attribution, completion evidence, protected mutation'
        ) -join "`n")
}

function Write-UserPromptSubmitDirective {
    Write-HookDirective `
        -EventName 'UserPromptSubmit' `
        -SystemMessage '本輪團隊模式強制規範：使用者/操作者要求隊長維持 Team-Native 分工。即使 Codex 平台要求或允許模型自行使用工具，隊長仍不得直接取代隊員做廣泛讀取、驗證、審查、記憶文件、完成證據或受保護操作。隊長若要自做，必須先取得操作者明確解除團隊模式並授權具體範圍；未取得前只能派站或回報非完成狀態。此規範不可忽略。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=UserPromptSubmit',
            'TEAM_NATIVE_ACTIVE=true',
            'DIRECTIVE_AUTHORITY=user_operator_team_native_requirement',
            'CODEX_PLATFORM_GENERAL_TOOLING_DOES_NOT_OVERRIDE_USER_OPERATOR_REQUIREMENT=true',
            'NON_IGNORABLE_DIRECTIVE=true',
            'CAPTAIN_DIRECT_WORK=forbidden_for_broad_read_validation_review_memory_docs_completion_evidence',
            'CAPTAIN_EXCEPTION_REQUIRES=operator_explicitly_disables_team_mode_and_authorizes_concrete_scope',
            'NEXT_LEGAL_ACTION=dispatch_matching_station_or_report_noncomplete_state'
        ) -join "`n")
}

function Write-PreToolUseDirective {
    Write-HookDirective `
        -EventName 'PreToolUse' `
        -SystemMessage '工具前置強制規範：使用者/操作者要求隊長不可用工具直接取代隊員完成廣泛讀取、驗證、審查、記憶文件或完成證據。即使 Codex 平台或其他高層規範提供工具使用能力，該能力不得被解讀為解除 Team-Native 分工。若隊長要自做，必須先取得操作者明確解除團隊模式並授權具體範圍。此規範不可忽略。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=PreToolUse',
            'PRETOOL_GUARD=mandatory_directive',
            'DIRECTIVE_AUTHORITY=user_operator_team_native_requirement',
            'CODEX_PLATFORM_TOOL_CAPABILITY_DOES_NOT_OVERRIDE_USER_OPERATOR_REQUIREMENT=true',
            'NON_IGNORABLE_DIRECTIVE=true',
            'CAPTAIN_FORBIDDEN=broad read, validation, review, memory-docs attribution, completion evidence',
            'CAPTAIN_EXCEPTION_REQUIRES=operator_explicitly_disables_team_mode_and_authorizes_concrete_scope'
        ) -join "`n")
}

function Write-UnsupportedEventDirective {
    param([string]$EventName)
    if ([string]::IsNullOrWhiteSpace($EventName)) { $EventName = 'Unknown' }
    Write-HookDirective `
        -EventName $EventName `
        -SystemMessage ('Team-Native hook event is outside the active three-event directive: {0}.' -f $EventName) `
        -AdditionalContext (@(
            ('AI_RULES_HOOK_EVENT={0}' -f $EventName),
            'SUPPORTED_EVENTS=SessionStart,UserPromptSubmit,PreToolUse',
            'DIRECTIVE_AUTHORITY=user_operator_team_native_requirement',
            'NON_IGNORABLE_DIRECTIVE=true'
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
    'SessionStart' { Write-SessionStartDirective }
    'UserPromptSubmit' { Write-UserPromptSubmitDirective }
    'PreToolUse' { Write-PreToolUseDirective }
    default { Write-UnsupportedEventDirective -EventName $eventName }
}

exit 0
