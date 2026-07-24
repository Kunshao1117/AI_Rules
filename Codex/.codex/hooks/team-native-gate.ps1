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
        [string]$AdditionalContext,
        [string]$PermissionDecision,
        [string]$PermissionDecisionReason
    )

    $hookSpecificOutput = [ordered]@{
        hookEventName = $EventName
        additionalContext = $AdditionalContext
    }
    if (-not [string]::IsNullOrWhiteSpace($PermissionDecision)) {
        $hookSpecificOutput.permissionDecision = $PermissionDecision
        $hookSpecificOutput.permissionDecisionReason = $PermissionDecisionReason
    }

    [ordered]@{
        systemMessage = $SystemMessage
        hookSpecificOutput = $hookSpecificOutput
    } | ConvertTo-Json -Depth 8 -Compress
}

function Get-PreToolInputCommand {
    param([object]$Payload)

    $toolInput = Get-HookPropertyValue -Object $Payload -Names @('tool_input', 'toolInput')
    $command = Get-HookPropertyValue -Object $toolInput -Names @('command')
    if ($null -eq $command) { return '' }
    return [string]$command
}

function Test-ReadOnlyCommand {
    param([string]$Command)

    if ([string]::IsNullOrWhiteSpace($Command)) { return $false }
    if ($Command.Contains('`') -or $Command.Contains('$(') -or $Command -match '[;&|><]') { return $false }

    return $Command.Trim() -match '^(?i:(Get-Content|Get-Item|Get-ChildItem|Get-Command|Get-Help|Select-String|Test-Path|Resolve-Path|rg)\b|git\s+(?:status|diff|log|show|rev-parse|ls-files)\b)'
}

function Test-FastDeliveryRequested {
    param([object]$Payload)

    $markers = @('fast_delivery', 'fastDelivery', 'delivery_mode', 'deliveryMode', 'execution_lane', 'executionLane', 'execution_profile', 'executionProfile')
    foreach ($marker in $markers) {
        $value = Get-HookPropertyValue -Object $Payload -Names @($marker)
        if ($value -is [bool] -and $value) { return $true }
        if ([string]$value -match '^(?i:fast|fast-delivery|fast_delivery)$') { return $true }
    }

    return $false
}

function Get-EnvelopeValue {
    param(
        [object]$Payload,
        [object]$Envelope,
        [string[]]$Names
    )

    $value = Get-HookPropertyValue -Object $Envelope -Names $Names
    if ($null -ne $value) { return $value }
    return Get-HookPropertyValue -Object $Payload -Names $Names
}

function Test-TrustedExecutionEnvelope {
    param(
        [object]$Payload,
        [ref]$Reason
    )

    $envelope = Get-HookPropertyValue -Object $Payload -Names @('tool_execution_envelope')
    if ($null -eq $envelope -or $envelope -is [string]) {
        $Reason.Value = 'tool_execution_envelope is missing or malformed'
        return $false
    }

    $trust = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @('tool_execution_envelope_trust')
    if ([string]$trust -notmatch '^(?i:trusted)$') {
        $Reason.Value = 'tool_execution_envelope_trust is not trusted'
        return $false
    }

    $requiredFields = @(
        'board_id', 'station_id', 'handoff_packet_id', 'role_id', 'role_instance_id', 'assigned_specialist_skill',
        'requested_execution_channel', 'channel_capability', 'channel_invocation_status',
        'authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase',
        'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state',
        'delivery_artifact_id', 'delivery_artifact_type', 'delivery_artifact_status'
    )
    foreach ($field in $requiredFields) {
        $value = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @($field)
        if ([string]::IsNullOrWhiteSpace([string]$value)) {
            $Reason.Value = ('tool_execution_envelope is missing {0}' -f $field)
            return $false
        }
    }

    $issuer = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @('trusted_issuer', 'tool_envelope_issuer')
    $signature = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @('signature', 'tool_envelope_signature')
    $nonce = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @('nonce', 'tool_envelope_nonce')
    $issuedAt = Get-EnvelopeValue -Payload $Payload -Envelope $envelope -Names @('issued_at')
    foreach ($field in @(
        @{ Name = 'trusted issuer'; Value = $issuer },
        @{ Name = 'signature'; Value = $signature },
        @{ Name = 'nonce'; Value = $nonce },
        @{ Name = 'issued_at'; Value = $issuedAt }
    )) {
        if ([string]::IsNullOrWhiteSpace([string]$field.Value)) {
            $Reason.Value = ('tool_execution_envelope is missing {0}' -f $field.Name)
            return $false
        }
    }

    return $true
}

function Get-PreToolUseRoute {
    param([object]$Payload)

    if ($null -eq $Payload) {
        return [pscustomobject]@{ Route = 'deny'; ActionClass = 'unknown'; Reason = 'PreToolUse payload is malformed' }
    }

    $toolName = [string](Get-HookPropertyValue -Object $Payload -Names @('tool_name', 'toolName'))
    if ([string]::IsNullOrWhiteSpace($toolName)) {
        return [pscustomobject]@{ Route = 'deny'; ActionClass = 'unknown'; Reason = 'PreToolUse payload is missing tool_name' }
    }

    $command = Get-PreToolInputCommand -Payload $Payload
    $isShellTool = $toolName -match '^(?i:Bash|shell_command|powershell|pwsh)$'
    $isReadOnly = ($isShellTool -and (Test-ReadOnlyCommand -Command $command)) -or ($toolName -match '(?i)(?:^|__)(read|list|search|find|view|status|inspect|fetch|describe)(?:$|__)')
    if ($isReadOnly) {
        return [pscustomobject]@{ Route = 'read-only'; ActionClass = 'low-risk-read-only'; Reason = 'strict read-only tool action' }
    }

    $isProtected = $toolName -match '(?i)(apply_patch|edit|write|delete|remove|memory|git|commit|push|release|deploy|install|credential|secret|token|auth|cloud|external|send|publish|create|update|set|move|copy|stage|merge|rebase|reset|checkout|stash|clean)' -or $command -match '(?i)\b(Remove-Item|Set-Content|Add-Content|Out-File|New-Item|Copy-Item|Move-Item|Rename-Item|Clear-Content|git\s+(?:add|commit|push|tag|merge|rebase|reset|checkout|stash|clean)|(?:npm|pnpm|yarn|pip)\s+(?:install|publish)|curl\b|Invoke-WebRequest\b|Invoke-RestMethod\b)'
    if ($isProtected) {
        return [pscustomobject]@{ Route = 'protected'; ActionClass = 'high-risk-or-protected'; Reason = 'protected or high-risk tool action' }
    }

    if (Test-FastDeliveryRequested -Payload $Payload) {
        return [pscustomobject]@{ Route = 'fast-delivery'; ActionClass = 'guarded-fast-delivery'; Reason = 'fast-delivery marker' }
    }

    return [pscustomobject]@{ Route = 'guarded'; ActionClass = 'write-capable-or-unclassified'; Reason = 'tool action is not strictly read-only' }
}

function Write-PreToolUseFastPath {
    param([string]$Route, [string]$ActionClass)

    Write-HookDirective `
        -EventName 'PreToolUse' `
        -SystemMessage '工具前置檢查已判定為低風險路徑；完整 Team-Native 提示不注入，但既有授權與受保護操作限制完全不變。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=PreToolUse',
            ('PRETOOL_ROUTE={0}' -f $Route),
            ('ACTION_CLASS={0}' -f $ActionClass),
            'FULL_PRETOOL_GATE=skipped',
            'AUTHORIZATION=unchanged',
            'PROTECTED_ACTIONS=not-authorized'
        ) -join "`n")
}

function Write-PreToolUseDenied {
    param([string]$Reason, [string]$ActionClass)

    Write-HookDirective `
        -EventName 'PreToolUse' `
        -SystemMessage '工具前置檢查已拒絕此高風險、受保護或無法判定的操作：缺少可驗證的 Team-Native execution envelope。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=PreToolUse',
            'PRETOOL_ROUTE=fail-closed',
            ('ACTION_CLASS={0}' -f $ActionClass),
            'TOOL_EXECUTION_ENVELOPE=required',
            'FAIL_CLOSED=true',
            ('BLOCK_REASON={0}' -f $Reason)
        ) -join "`n") `
        -PermissionDecision 'deny' `
        -PermissionDecisionReason $Reason
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
    param([object]$Payload)

    $route = Get-PreToolUseRoute -Payload $Payload
    if ($route.Route -eq 'deny') {
        Write-PreToolUseDenied -Reason $route.Reason -ActionClass $route.ActionClass
        return
    }

    if ($route.Route -eq 'read-only') {
        Write-PreToolUseFastPath -Route $route.Route -ActionClass $route.ActionClass
        return
    }

    $envelopeReason = ''
    if (-not (Test-TrustedExecutionEnvelope -Payload $Payload -Reason ([ref]$envelopeReason))) {
        Write-PreToolUseDenied -Reason $envelopeReason -ActionClass $route.ActionClass
        return
    }

    if ($route.Route -eq 'fast-delivery') {
        Write-PreToolUseFastPath -Route $route.Route -ActionClass $route.ActionClass
        return
    }

    Write-HookDirective `
        -EventName 'PreToolUse' `
        -SystemMessage '工具前置強制規範：使用者/操作者要求隊長不可用工具直接取代隊員完成廣泛讀取、驗證、審查、記憶文件或完成證據。即使 Codex 平台或其他高層規範提供工具使用能力，該能力不得被解讀為解除 Team-Native 分工。若隊長要自做，必須先取得操作者明確解除團隊模式並授權具體範圍。此規範不可忽略。' `
        -AdditionalContext (@(
            'AI_RULES_HOOK_EVENT=PreToolUse',
            'PRETOOL_GUARD=mandatory_directive',
            ('ACTION_CLASS={0}' -f $route.ActionClass),
            'TOOL_EXECUTION_ENVELOPE_TRUST=trusted',
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
    'PreToolUse' { Write-PreToolUseDirective -Payload $payload }
    default { Write-UnsupportedEventDirective -EventName $eventName }
}

exit 0
