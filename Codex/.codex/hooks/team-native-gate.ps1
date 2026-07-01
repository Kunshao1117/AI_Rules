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

    if ($null -ne $Text) {
        $Text = $Text.TrimStart([char]0xFEFF)
    }

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return [PSCustomObject]@{ __parse_error = 'empty input' }
    }

    try {
        return ($Text | ConvertFrom-Json -ErrorAction Stop)
    } catch {
        return [PSCustomObject]@{ __parse_error = $_.Exception.Message }
    }
}

function Get-HookHostVerifiedToolLayerEvidence {
    $json = $env:CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_JSON
    if (-not [string]::IsNullOrWhiteSpace($json)) {
        $evidence = ConvertFrom-HookJson -Text $json
        if (-not (Get-HookProperty -Object $evidence -Name '__parse_error')) {
            return $evidence
        }
    }

    $path = $env:CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_PATH
    if (-not [string]::IsNullOrWhiteSpace($path)) {
        try {
            if (Test-Path -LiteralPath $path -PathType Leaf) {
                $fileJson = Get-Content -LiteralPath $path -Raw -Encoding UTF8
                $evidence = ConvertFrom-HookJson -Text $fileJson
                if (-not (Get-HookProperty -Object $evidence -Name '__parse_error')) {
                    return $evidence
                }
            }
        } catch {
            return $null
        }
    }

    return $null
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
        'authorization_source',
        'authorization_evidence',
        'authorization_scope',
        'authorization_target',
        'authorization_phase',
        'authorization_expiry',
        'authorization_resolution_state',
        'authorized_action',
        'authorized_files',
        'protected_authorization',
        'captain_team_board',
        'team_board',
        'board',
        'station',
        'station_id',
        'handoff',
        'handoff_packet_id',
        'role',
        'role_id',
        'role_instance_id',
        'assigned_specialist_skill',
        'channel',
        'requested_execution_channel',
        'channel_capability',
        'channel_invocation_status',
        'execution_channel',
        'station_state',
        'evidence_state',
        'station_channel_state',
        'native_subagent_authorization_state',
        'captain_supervision_state',
        'tool_payload_evidence_gap',
        'completion_state',
        'delivery_artifacts',
        'delivery_artifact_id',
        'delivery_artifact_type',
        'delivery_artifact_status',
        'implementation_delivery',
        'change_delivery',
        'memory_delivery',
        'memory_docs_delivery',
        'review_delivery',
        'validation_delivery',
        'direct_exceptions',
        'deep_read_scope',
        'captain_verify_read_scope',
        'unread_scope',
        'director_risk_close_evidence',
        'director_risk_close_scope',
        'director_risk_close_target',
        'director_risk_close_authorization',
        'risk_close_evidence',
        'risk_close_scope',
        'risk_close_target',
        'risk_closure_evidence',
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
        'last_assistant_message',
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

function Add-HookObjectRecordValues {
    param(
        [object]$Value,
        [object]$Records
    )

    if ($null -eq $Value) { return }
    if ($Value -is [string]) { return }

    if (($Value -is [System.Collections.IDictionary]) -or ($Value -is [System.Management.Automation.PSCustomObject])) {
        $Records.Add($Value)
        return
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($entry in $Value) {
            if (($entry -is [System.Collections.IDictionary]) -or ($entry -is [System.Management.Automation.PSCustomObject])) {
                $Records.Add($entry)
            }
        }
    }
}

function Get-HookToolEnvelopeCandidateRecords {
    param([object]$Payload)

    $records = New-Object System.Collections.Generic.List[object]
    foreach ($field in @(
        'tool_execution_envelope',
        'tool_envelope',
        'execution_envelope',
        'permission_request_envelope',
        'permission_envelope',
        'runtime_envelope',
        'tool_payload_envelope'
    )) {
        Add-HookObjectRecordValues -Value (Get-HookProperty -Object $Payload -Name $field) -Records $records
    }

    return @($records.ToArray())
}

function Get-HookExecutionReceiptCandidateRecords {
    param([object]$Payload)

    $records = New-Object System.Collections.Generic.List[object]
    foreach ($field in @(
        'tool_execution_receipt',
        'tool_receipt',
        'execution_receipt',
        'permission_request_receipt',
        'permission_receipt',
        'runtime_receipt',
        'tool_payload_receipt'
    )) {
        Add-HookObjectRecordValues -Value (Get-HookProperty -Object $Payload -Name $field) -Records $records
    }

    return @($records.ToArray())
}

function Test-HookToolEnvelopeTrusted {
    param([object]$Record)

    if ($null -eq $Record) { return $false }

    $recordText = (@(Get-NamedStringLeafValues -Value $Record -Prefix 'tool_envelope') -join ' ')
    if ($recordText -match '(?i)\b(untrusted|unverified|model|assistant|self[-_ ]?reported|self[-_ ]?asserted|self[-_ ]?filled|synthetic|transcript|conversation|user[-_ ]?supplied|user[-_ ]?provided|false)\b') {
        return $false
    }

    $hostVerifiedText = Get-HookRecordFieldValue -Record $Record -Names @(
        'host_platform_verified_receipt',
        'host_platform_verified_envelope',
        'host_verified_receipt',
        'host_verified_envelope',
        'platform_verified_receipt',
        'platform_verified_envelope',
        'tool_layer_host_verified',
        'tool_layer_platform_verified'
    )
    $hostVerificationSourceText = Get-HookRecordFieldValue -Record $Record -Names @(
        'host_verification_source',
        'platform_verification_source',
        'host_receipt_verified_by',
        'platform_receipt_verified_by',
        'host_envelope_verified_by',
        'platform_envelope_verified_by',
        'verification_authority',
        'verified_by_host',
        'verified_by_platform'
    )
    $hostVerificationScopeText = Get-HookRecordFieldValue -Record $Record -Names @(
        'host_verification_scope',
        'platform_verification_scope',
        'verification_scope',
        'receipt_verification_scope',
        'envelope_verification_scope'
    )
    if ([string]::IsNullOrWhiteSpace($hostVerifiedText) -or
        [string]::IsNullOrWhiteSpace($hostVerificationSourceText) -or
        [string]::IsNullOrWhiteSpace($hostVerificationScopeText)) {
        return $false
    }

    $hostVerifiedLooksPositive = ($hostVerifiedText -notmatch '(?i)\b(false|no|not[-_ ]?verified|unverified|missing|none|unknown|self[-_ ]?reported|self[-_ ]?asserted|self[-_ ]?filled)\b') -and
        ($hostVerifiedText -match '(?i)\b(true|verified|host[-_ ]?verified|platform[-_ ]?verified|valid)\b')
    $hostVerificationSourceLooksHostOnly = ($hostVerificationSourceText -notmatch '(?i)\b(model|assistant|self[-_ ]?reported|self[-_ ]?asserted|self[-_ ]?filled|synthetic|transcript|conversation|user[-_ ]?supplied|user[-_ ]?provided)\b') -and
        ($hostVerificationSourceText -match '(?i)\b(codex[-_ ]?host|codex[-_ ]?platform|platform[-_ ]?host|platform[-_ ]?runtime|tool[-_ ]?host|runtime[-_ ]?host|permission[-_ ]?system)\b')
    $hostVerificationScopeLooksToolLayer = ($hostVerificationScopeText -notmatch '(?i)\b(model|assistant|self[-_ ]?reported|self[-_ ]?asserted|self[-_ ]?filled|transcript|conversation|user[-_ ]?supplied|user[-_ ]?provided)\b') -and
        ($hostVerificationScopeText -match '(?i)\b(tool[-_ ]?execution[-_ ]?envelope|tool[-_ ]?execution[-_ ]?receipt|tool[-_ ]?envelope|tool[-_ ]?receipt|permission[-_ ]?envelope|permission[-_ ]?receipt|runtime[-_ ]?envelope|runtime[-_ ]?receipt|tool[-_ ]?layer)\b')
    if (-not ($hostVerifiedLooksPositive -and $hostVerificationSourceLooksHostOnly -and $hostVerificationScopeLooksToolLayer)) {
        return $false
    }

    $trustedIssuerText = Get-HookRecordFieldValue -Record $Record -Names @(
        'trusted_issuer',
        'trusted issuer',
        'tool_layer_trusted_issuer',
        'runtime_trusted_issuer',
        'trusted_issuer_source'
    )
    $sourceText = Get-HookRecordFieldValue -Record $Record -Names @(
        'receipt_source',
        'source',
        'source_type',
        'authority_source',
        'issued_by',
        'verified_by',
        'runtime_source'
    )
    $trustText = Get-HookRecordFieldValue -Record $Record -Names @(
        'trusted',
        'is_trusted',
        'trust',
        'trust_state',
        'trust_status',
        'platform_trust',
        'runtime_trust',
        'hook_trust',
        'verification_state'
    )
    $signatureText = Get-HookRecordFieldValue -Record $Record -Names @(
        'signature',
        'signature_state',
        'signature_status',
        'signature_verification',
        'signature_verified',
        'receipt_signature',
        'envelope_signature',
        'platform_signature',
        'runtime_signature',
        'signed_by'
    )
    $nonceText = Get-HookRecordFieldValue -Record $Record -Names @(
        'nonce_state',
        'nonce_status',
        'freshness',
        'freshness_state',
        'freshness_status',
        'nonce',
        'nonce_value',
        'receipt_nonce',
        'envelope_nonce',
        'runtime_nonce'
    )
    $combined = ("{0} {1} {2} {3} {4}" -f $trustedIssuerText, $sourceText, $trustText, $signatureText, $nonceText).Trim()
    if ([string]::IsNullOrWhiteSpace($combined)) { return $false }

    if ([string]::IsNullOrWhiteSpace($trustedIssuerText) -or
        [string]::IsNullOrWhiteSpace($sourceText) -or
        [string]::IsNullOrWhiteSpace($trustText) -or
        [string]::IsNullOrWhiteSpace($signatureText) -or
        [string]::IsNullOrWhiteSpace($nonceText)) {
        return $false
    }

    $trustedIssuerLooksToolLayer = $trustedIssuerText -match '(?i)\b(codex[-_ ]?tool[-_ ]?layer|tool[-_ ]?layer|codex[-_ ]?runtime|codex[-_ ]?host|platform[-_ ]?runtime|hook[-_ ]?runner|tool[-_ ]?runner|permission[-_ ]?system)\b'
    $sourceLooksRuntime = $sourceText -match '(?i)\b(codex[-_ ]?tool[-_ ]?layer|tool[-_ ]?layer|codex[-_ ]?runtime|codex[-_ ]?host|platform[-_ ]?runtime|hook[-_ ]?runner|tool[-_ ]?runner|permission[-_ ]?system)\b'
    $trustLooksPositive = $trustText -match '(?i)\b(true|trusted|verified|valid)\b'
    $signatureLooksPositive = $signatureText -match '(?i)\b(verified|signed|valid)\b'
    $nonceLooksFresh = ($nonceText -notmatch '(?i)\b(missing|empty|null|none|stale|expired|replay(?:ed)?|reused|invalid)\b') -and
        ($nonceText -match '(?i)\b(fresh|current|valid)\b')
    return ($trustedIssuerLooksToolLayer -and $sourceLooksRuntime -and $trustLooksPositive -and $signatureLooksPositive -and $nonceLooksFresh)
}

function Get-HookTrustedToolEnvelopeRecords {
    param([object]$Payload)

    $trustedRecords = New-Object System.Collections.Generic.List[object]
    foreach ($record in @(Get-HookToolEnvelopeCandidateRecords -Payload $Payload)) {
        if (Test-HookToolEnvelopeTrusted -Record $record) {
            $trustedRecords.Add($record)
        }
    }

    return @($trustedRecords.ToArray())
}

function Get-HookTrustedExecutionReceiptRecords {
    param([object]$Payload)

    $trustedRecords = New-Object System.Collections.Generic.List[object]
    foreach ($record in @(Get-HookExecutionReceiptCandidateRecords -Payload $Payload)) {
        if (Test-HookToolEnvelopeTrusted -Record $record) {
            $trustedRecords.Add($record)
        }
    }

    return @($trustedRecords.ToArray())
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

function New-HookDiagnosticReason {
    param(
        [string]$Reason,
        [string]$ActionType,
        [string]$BlockType,
        [string]$ReasonCode,
        [string[]]$MissingFields
    )

    if ([string]::IsNullOrWhiteSpace($ActionType)) {
        $ActionType = 'governance-gated action'
    }
    if ([string]::IsNullOrWhiteSpace($BlockType)) {
        $BlockType = 'Team-Native hard gate'
    }
    if ([string]::IsNullOrWhiteSpace($Reason)) {
        $Reason = 'No detailed reason was supplied by the guard.'
    }
    if ([string]::IsNullOrWhiteSpace($ReasonCode)) {
        $ReasonCode = Get-HookReasonCode -Reason $Reason
    }
    if (($null -eq $MissingFields) -or ($MissingFields.Count -eq 0)) {
        $MissingFields = @(
            'captain_team_board/team_board/board/team_native_trace',
            'station_id',
            'handoff_packet_id',
            'role_id',
            'role_instance_id',
            'assigned_specialist_skill',
            'requested_execution_channel',
            'channel_capability',
            'channel_invocation_status',
            'authorization_evidence',
            'authorization_target',
            'authorization_scope',
            'authorization_phase',
            'authorization_expiry',
            'authorization_resolution_state',
            'host_verified_tool_layer_envelope',
            'host_verified_tool_layer_receipt',
            'delivery_artifacts'
            'completion_evidence'
        )
    }

    return (@(
        'Governance hard gate hit. Treat this as designed policy enforcement, not a tool failure.',
        ('Block type: {0}.' -f $BlockType),
        ('Current action: {0}.' -f $ActionType),
        ('Blocked action: {0}.' -f $ActionType),
        ('Reason code: {0}.' -f $ReasonCode),
        ('Reason: {0}' -f $Reason),
        ('Missing structured fields: {0}.' -f (@($MissingFields) -join ', ')),
        'Missing evidence categories: task board, station, station handoff packet, role identity, channel state, scope-bound authorization, host/platform verified tool-layer envelope/receipt, delivery artifacts, completion evidence.',
        'Trusted fields: current structured payload fields for Team-Native board, station, handoff, role, channel, authorization target/scope/phase/expiry, structured delivery artifacts, completion state, and host/platform verified tool-layer envelope/receipt supplied through the hook host evidence channel.',
        'Untrusted fields: prompt, user_prompt, response, output, content, last_assistant_message, transcript, conversation_history, history, messages, text-only team_native_trace, and self-asserted tool envelope/receipt or protected authorization without host/platform verified receipt.',
        'Missing evidence must be supplied in the current structured payload; natural-language GO, continue, fix it, handle this first, or historical transcript text is route/binding context only.',
        'Allowed next steps: stop the current action; report completion_state: blocked, validation_state: unverified, or closed-with-director-risk when explicitly scope-bound; bind any ordinary Director wording to the current visible plan, station, file set, command, authorization phase, and expiry before retrying the work.',
        'Forbidden next steps: do not retry with another tool, do not switch channels, do not use transcript text or prior assistant claims as authorization, do not treat a transcript as a permission source, do not claim completion, and do not perform memory, git, release, deploy, install, credential, or external-state mutation.',
        'Minimum unblock conditions: provide current structured task board, station, handoff packet, role identity, channel state, scope-bound authorization target/scope/phase/expiry, trusted tool-layer envelope and receipt when protected mutation is requested, structured delivery artifacts with returned status, and explicit completion evidence for the current phase.'
    ) -join ' ')
}

function Get-HookReasonCode {
    param([string]$Reason)

    if ([string]::IsNullOrWhiteSpace($Reason)) { return 'TN-HOOK-GOVERNANCE-GATE' }
    if ($Reason -match '(?i)not valid JSON|empty or not valid JSON|parse') { return 'TN-HOOK-INVALID-INPUT' }
    if ($Reason -match '(?i)structured Team-Native payload|tool_payload_evidence_gap') { return 'TN-HOOK-STRUCTURED-PAYLOAD-MISSING' }
    if ($Reason -match '(?i)scoped write authorization|target path|current target') { return 'TN-HOOK-WRITE-SCOPE-MISMATCH' }
    if ($Reason -match '(?i)Write-capable') { return 'TN-HOOK-WRITE-EVIDENCE-MISSING' }
    if ($Reason -match '(?i)bypass permission mode') { return 'TN-HOOK-PROTECTED-BYPASS-UNAUTHORIZED' }
    if ($Reason -match '(?i)host/platform verified|tool-layer envelope is unverified|tool-layer receipt is unverified') { return 'TN-HOOK-TOOL-LAYER-RECEIPT-UNVERIFIED' }
    if ($Reason -match '(?i)Protected mutation requires explicit protected authorization|protected authorization evidence') { return 'TN-HOOK-PROTECTED-AUTH-MISSING' }
    if ($Reason -match '(?i)trust bypass') { return 'TN-HOOK-TRUST-BYPASS' }
    if ($Reason -match '(?i)retrying with another tool|switching channels|policy block') { return 'TN-HOOK-POST-BLOCK-BYPASS' }
    if ($Reason -match '(?i)closed-with-director-risk') { return 'TN-HOOK-RISK-CLOSE-EVIDENCE-MISSING' }
    if ($Reason -match '(?i)Completion claim|delivery artifacts') { return 'TN-HOOK-COMPLETION-ARTIFACTS-MISSING' }
    return 'TN-HOOK-GOVERNANCE-GATE'
}

function Exit-Block {
    param(
        [string]$EventName,
        [string]$Reason
    )

    $diagnosticReason = New-HookDiagnosticReason -Reason $Reason -ActionType $EventName

    switch ($EventName) {
        'PreToolUse' {
            Write-HookJson @{
                hookSpecificOutput = @{
                    hookEventName            = 'PreToolUse'
                    permissionDecision       = 'deny'
                    permissionDecisionReason = $diagnosticReason
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
                        message  = $diagnosticReason
                    }
                }
            }
            exit 0
        }
        'Stop' {
            Write-HookJson @{
                decision = 'block'
                reason   = $diagnosticReason
            }
            exit 0
        }
        'SubagentStop' {
            Write-HookJson @{
                decision = 'block'
                reason   = $diagnosticReason
            }
            exit 0
        }
        default {
            [Console]::Error.WriteLine($diagnosticReason)
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

function Test-HookStructuredFieldHasConcreteValue {
    param(
        [object]$Payload,
        [string[]]$Fields
    )

    $invalidValues = @(
        '',
        'none',
        'null',
        '[]',
        '{}',
        'missing',
        'not set',
        'not-set',
        'n/a',
        'na',
        'not applicable',
        'not-applicable',
        'unavailable',
        'not-authorized',
        'blocked',
        'unverified',
        'standby',
        'closed-with-director-risk'
    )

    foreach ($field in $Fields) {
        $value = Get-HookProperty -Object $Payload -Name $field
        if ($null -eq $value) { continue }
        foreach ($item in @(Get-StringLeafValues -Value $value)) {
            $text = ([string]$item).Trim()
            if ([string]::IsNullOrWhiteSpace($text)) { continue }
            if ($invalidValues -contains $text.ToLowerInvariant()) { continue }
            return $true
        }
    }

    foreach ($record in @(Get-HookTrustedToolEnvelopeRecords -Payload $Payload)) {
        foreach ($field in $Fields) {
            $value = Get-HookRecordFieldValue -Record $record -Names @($field)
            if ([string]::IsNullOrWhiteSpace($value)) { continue }
            foreach ($item in @(Get-StringLeafValues -Value $value)) {
                $text = ([string]$item).Trim()
                if ([string]::IsNullOrWhiteSpace($text)) { continue }
                if ($invalidValues -contains $text.ToLowerInvariant()) { continue }
                return $true
            }
        }
    }

    return $false
}

function Test-HasStructuredTeamNativePayload {
    param([object]$Payload)

    $requirements = @(
        @{ Label = 'board'; Fields = @('captain_team_board', 'team_board', 'board', 'team_native_trace') },
        @{ Label = 'station_id'; Fields = @('station_id') },
        @{ Label = 'handoff_packet_id'; Fields = @('handoff_packet_id') },
        @{ Label = 'role_id'; Fields = @('role_id') },
        @{ Label = 'role_instance_id'; Fields = @('role_instance_id') },
        @{ Label = 'assigned_specialist_skill'; Fields = @('assigned_specialist_skill') },
        @{ Label = 'requested_execution_channel'; Fields = @('requested_execution_channel') },
        @{ Label = 'channel_capability'; Fields = @('channel_capability') },
        @{ Label = 'channel_invocation_status'; Fields = @('channel_invocation_status') }
    )

    foreach ($requirement in $requirements) {
        if (-not (Test-HookStructuredFieldHasConcreteValue -Payload $Payload -Fields $requirement.Fields)) {
            return $false
        }
    }

    return $true
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
        '(?im)^\s*(?:&\s*)?(?:\.\\|\.\/)?(?:Scripts[\\\/])?Deploy\.ps1\b',
        '(?i)\b(?:powershell|pwsh)(?:\.exe)?\b[^\r\n;|&]*\b-File\s+["'']?[^"''\r\n;|&]*\bDeploy\.ps1\b',
        '(?im)^\s*(?:&\s*)?(?:\.\\|\.\/)?(?:Codex[\\\/])?install\.ps1\b',
        '(?i)\b(?:powershell|pwsh)(?:\.exe)?\b[^\r\n;|&]*\b-File\s+["'']?[^"''\r\n;|&]*\binstall\.ps1\b',
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
        @{ Pattern = '(?im)^\s*(?:&\s*)?(?:\.\\|\.\/)?(?:Scripts[\\\/])?Deploy\.ps1\b|(?i)\b(?:powershell|pwsh)(?:\.exe)?\b[^\r\n;|&]*\b-File\s+["'']?[^"''\r\n;|&]*\bDeploy\.ps1\b|(?m)^\s*(?:mcp__\S*(?:deploy)\S*|deploy)\s*$'; Key = 'deploy' },
        @{ Pattern = '(?im)^\s*(?:&\s*)?(?:\.\\|\.\/)?(?:Codex[\\\/])?install\.ps1\b|(?i)\b(?:powershell|pwsh)(?:\.exe)?\b[^\r\n;|&]*\b-File\s+["'']?[^"''\r\n;|&]*\binstall\.ps1\b'; Key = 'install' },
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
        '(?i)\btee\b(?:\s+-(?:a|-append|i))*\s+(?:"[^"\r\n]+"|''[^''\r\n]+''|[^"''\s|;&]+)',
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

    $redirectPattern = '(?m)(?:^|[\s|;&])(?:\d?>{1,2}|>{1,2})\s*(?!&\d)(?:"([^"\r\n]+)"|''([^''\r\n]+)''|([^"''\s\r\n|;&]+))'
    foreach ($match in [regex]::Matches($Text, $redirectPattern)) {
        $targetValue = ''
        for ($groupIndex = 1; $groupIndex -lt $match.Groups.Count; $groupIndex++) {
            if (-not [string]::IsNullOrWhiteSpace($match.Groups[$groupIndex].Value)) {
                $targetValue = $match.Groups[$groupIndex].Value
                break
            }
        }
        if (-not (Test-IsIgnoredShellWriteTarget -Target $targetValue)) {
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
    Add-HookObjectRecordValues -Value $value -Records $records

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

function Get-HookNormalizedRecordFieldValues {
    param(
        [object]$Record,
        [string[]]$Names
    )

    $values = New-Object System.Collections.Generic.List[string]
    foreach ($name in $Names) {
        $value = Get-HookRecordFieldValue -Record $Record -Names @($name)
        if ([string]::IsNullOrWhiteSpace($value)) { continue }
        foreach ($item in @(Get-StringLeafValues -Value $value)) {
            $text = ([string]$item).Trim().Trim('"', "'", '`').Trim()
            if ([string]::IsNullOrWhiteSpace($text)) { continue }
            $values.Add($text.ToLowerInvariant())
        }
    }

    return @($values.ToArray() | Select-Object -Unique)
}

function Test-HookRecordSetsIntersect {
    param(
        [string[]]$Left,
        [string[]]$Right
    )

    foreach ($leftValue in @($Left)) {
        if ([string]::IsNullOrWhiteSpace($leftValue)) { continue }
        foreach ($rightValue in @($Right)) {
            if ([string]::IsNullOrWhiteSpace($rightValue)) { continue }
            if ($leftValue -eq $rightValue) { return $true }
        }
    }

    return $false
}

function Test-HookEnvelopeReceiptIdentityMatch {
    param(
        [object]$Envelope,
        [object]$Receipt
    )

    $envelopeIds = @(Get-HookNormalizedRecordFieldValues -Record $Envelope -Names @(
        'envelope_id',
        'tool_execution_envelope_id',
        'execution_envelope_id',
        'tool_envelope_id',
        'id'
    ))
    $receiptEnvelopeIds = @(Get-HookNormalizedRecordFieldValues -Record $Receipt -Names @(
        'envelope_id',
        'tool_execution_envelope_id',
        'execution_envelope_id',
        'receipt_envelope_id',
        'tool_envelope_id',
        'envelope'
    ))
    if (($envelopeIds.Count -gt 0) -and ($receiptEnvelopeIds.Count -gt 0) -and
        (Test-HookRecordSetsIntersect -Left $envelopeIds -Right $receiptEnvelopeIds)) {
        return $true
    }

    $envelopeNonces = @(Get-HookNormalizedRecordFieldValues -Record $Envelope -Names @(
        'nonce',
        'nonce_value',
        'envelope_nonce',
        'runtime_nonce'
    ))
    $receiptNonces = @(Get-HookNormalizedRecordFieldValues -Record $Receipt -Names @(
        'nonce',
        'nonce_value',
        'receipt_nonce',
        'envelope_nonce',
        'runtime_nonce'
    ))
    if (($envelopeNonces.Count -gt 0) -and ($receiptNonces.Count -gt 0) -and
        (Test-HookRecordSetsIntersect -Left $envelopeNonces -Right $receiptNonces)) {
        return $true
    }

    return $false
}

function Test-HookReceiptDecisionAllows {
    param([object]$Receipt)

    $decisionText = Get-HookRecordFieldValue -Record $Receipt -Names @(
        'decision',
        'receipt_decision',
        'execution_receipt_decision',
        'permission_decision',
        'permissionDecision',
        'authorization_decision',
        'outcome',
        'status'
    )
    if ([string]::IsNullOrWhiteSpace($decisionText)) { return $false }
    if ($decisionText -match '(?i)\b(deny|denied|block|blocked|reject|rejected|not[-_ ]?authorized|unauthorized|forbidden|failed|failure|error)\b') {
        return $false
    }

    return ($decisionText -match '(?i)\b(allow|allowed|approved|permitted)\b')
}

function Get-HookReceiptActionScopeText {
    param([object]$Receipt)

    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($field in @(
        'action',
        'action_key',
        'requested_action',
        'receipt_action',
        'execution_action',
        'tool_action',
        'authorized_action',
        'protected_action',
        'command',
        'target',
        'action_target',
        'receipt_target',
        'authorization_target',
        'authorized_target',
        'protected_target',
        'scope',
        'receipt_scope',
        'authorization_scope',
        'authorized_scope',
        'protected_scope'
    )) {
        $value = Get-HookRecordFieldValue -Record $Receipt -Names @($field)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $parts.Add($value)
        }
    }

    return (@($parts.ToArray()) -join ' ').Trim()
}

function Test-HookReceiptMatchesActionAndScope {
    param(
        [object]$Receipt,
        [object]$AuthorizationRecord,
        [object]$ActionRequirement
    )

    $receiptText = Get-HookReceiptActionScopeText -Receipt $Receipt
    if ([string]::IsNullOrWhiteSpace($receiptText)) { return $false }

    $key = [string]$ActionRequirement.Key
    if ([string]::IsNullOrWhiteSpace($key)) { return $false }
    if (-not (Test-HookTextContainsLiteral -Text $receiptText -Needle $key)) {
        return $false
    }

    foreach ($token in @($ActionRequirement.DetailTokens)) {
        if (-not (Test-HookTextContainsLiteral -Text $receiptText -Needle $token)) {
            return $false
        }
    }

    $authorizationTargetScope = @(
        (Get-HookRecordFieldValue -Record $AuthorizationRecord -Names @('authorization_target')),
        (Get-HookRecordFieldValue -Record $AuthorizationRecord -Names @('authorization_scope'))
    ) -join ' '
    if ([string]::IsNullOrWhiteSpace($authorizationTargetScope)) { return $false }
    if (-not (Test-HookTextContainsLiteral -Text $authorizationTargetScope -Needle $key)) {
        return $false
    }
    foreach ($token in @($ActionRequirement.DetailTokens)) {
        if (-not (Test-HookTextContainsLiteral -Text $authorizationTargetScope -Needle $token)) {
            return $false
        }
    }

    return $true
}

function Test-HookProtectedAuthorizationHasMatchingToolReceipt {
    param(
        [object[]]$TrustedEnvelopes,
        [object[]]$TrustedReceipts,
        [object]$AuthorizationRecord,
        [object]$ActionRequirement
    )

    foreach ($envelope in @($TrustedEnvelopes)) {
        foreach ($receipt in @($TrustedReceipts)) {
            if (-not (Test-HookEnvelopeReceiptIdentityMatch -Envelope $envelope -Receipt $receipt)) { continue }
            if (-not (Test-HookReceiptDecisionAllows -Receipt $receipt)) { continue }
            if (-not (Test-HookReceiptMatchesActionAndScope -Receipt $receipt -AuthorizationRecord $AuthorizationRecord -ActionRequirement $ActionRequirement)) { continue }
            return $true
        }
    }

    return $false
}

function Test-HasProtectedAuthorizationEvidence {
    param(
        [string]$ActionText,
        [string]$EvidenceText,
        [object]$Payload,
        [object]$HostVerifiedToolLayerEvidence
    )

    $requirements = @(Get-HookProtectedActionRequirements -ActionText $ActionText)
    if ($requirements.Count -eq 0) { return $false }

    if ($null -eq $HostVerifiedToolLayerEvidence) { return $false }

    $trustedToolEnvelopeRecords = @(Get-HookTrustedToolEnvelopeRecords -Payload $HostVerifiedToolLayerEvidence)
    if ($trustedToolEnvelopeRecords.Count -eq 0) { return $false }

    $trustedExecutionReceiptRecords = @(Get-HookTrustedExecutionReceiptRecords -Payload $HostVerifiedToolLayerEvidence)
    if ($trustedExecutionReceiptRecords.Count -eq 0) { return $false }

    $records = @(Get-HookProtectedAuthorizationRecords -Payload $Payload)
    if ($records.Count -eq 0) { return $false }

    foreach ($requirement in $requirements) {
        $isCovered = $false
        foreach ($record in $records) {
            if ((Test-HookProtectedAuthorizationRecordMatchesAction -Record $record -ActionRequirement $requirement) -and
                (Test-HookProtectedAuthorizationHasMatchingToolReceipt -TrustedEnvelopes $trustedToolEnvelopeRecords -TrustedReceipts $trustedExecutionReceiptRecords -AuthorizationRecord $record -ActionRequirement $requirement)) {
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

    $pathPattern = '(?i)(?:[A-Za-z]:)?(?:\.{1,2}[\\/])?(?:[\p{L}\p{N}_. ()-]+[\\/])+[\p{L}\p{N}_. ()-]+|(?<![\w.-])[\p{L}\p{N}_.-]+\.[\p{L}\p{N}][\p{L}\p{N}._-]*(?![\w.-])'
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
        '(?m)(?:^|[\s|;&])(?:\d?>{1,2}|>{1,2})\s*(?!&\d)(?:"([^"\r\n]+)"|''([^''\r\n]+)''|([^"''`\s\r\n|;&]+))',
        '(?i)\btee\b(?:\s+-(?:a|-append|i))*\s+(?:"([^"\r\n]+)"|''([^''\r\n]+)''|([^"''`\s\r\n|;&]+))',
        '(?i)\bopen\s*\(\s*["'']([^"'']+)["'']\s*,\s*["''][^"'']*[wax+][^"'']*["'']',
        '(?i)\bPath\s*\(\s*["'']([^"'']+)["'']\s*\)\.write_(?:text|bytes)\s*\(',
        '(?i)\b(?:fs\.)?(?:writeFileSync|writeFile|appendFileSync|appendFile)\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\bFile\.write\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\bfile_put_contents\s*\(\s*["'']([^"'']+)["'']',
        '(?i)\[IO\.File\]::Write(?:AllText|AllBytes|AllLines)\s*\(\s*["'']([^"'']+)["'']'
    )
    foreach ($pattern in $commandPatterns) {
        foreach ($match in [regex]::Matches($Text, $pattern)) {
            $targetValue = ''
            for ($groupIndex = $match.Groups.Count - 1; $groupIndex -ge 1; $groupIndex--) {
                if (-not [string]::IsNullOrWhiteSpace($match.Groups[$groupIndex].Value)) {
                    $targetValue = $match.Groups[$groupIndex].Value
                    break
                }
            }
            if ([string]::IsNullOrWhiteSpace($targetValue)) { continue }
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
    $hasScope = $Text -match '(?i)(authorization_scope|authorized_files|exclusive_task_scope)'
    $hasTarget = $Text -match '(?i)(authorization_target|authorized_action|authorized_files)'
    $hasPhase = $Text -match '(?i)(authorization_phase|current\s+phase|phase[- ]?bound|formal[- ]?write|current\s+visible\s+plan|current\s+station)'
    $hasExpiry = $Text -match '(?i)(authorization_expiry|current\s+(task|phase|turn)|this\s+(task|phase|turn)|task\s+only|phase\s+only|scoped\s+to\s+current|expires?\s+at)'
    return ($hasAuthorization -and $hasScope -and $hasTarget -and $hasPhase -and $hasExpiry)
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
    $englishSignal = $Text -match '(?i)(GO\b|continue|do\s+that|as\s+planned|what\s+now|Wave\s+\d+|implementation|fix|repair|build|audit|Doctor|commit|push|release|deploy|memory|hook|Team-Native|subagent|workflow|governance)'
    $zhSignals = @(
        (New-UnicodeString -Codes @(0x7E7C, 0x7E8C)),
        (New-UnicodeString -Codes @(0x4FEE, 0x6B63)),
        (New-UnicodeString -Codes @(0x4FEE, 0x5FA9)),
        (New-UnicodeString -Codes @(0x5EFA, 0x69CB)),
        (New-UnicodeString -Codes @(0x9A57, 0x8B49)),
        (New-UnicodeString -Codes @(0x9264, 0x5B50)),
        (New-UnicodeString -Codes @(0x5718, 0x968A)),
        (New-UnicodeString -Codes @(0x5DE5, 0x4F5C, 0x6D41)),
        (New-UnicodeString -Codes @(0x5148, 0x8655, 0x7406)),
        (New-UnicodeString -Codes @(0x56DE, 0x53BB, 0x4FEE, 0x6B63)),
        (New-UnicodeString -Codes @(0x6240, 0x4EE5, 0x5462))
    )
    foreach ($signal in $zhSignals) {
        if ($Text.Contains($signal)) { return $true }
    }
    return $englishSignal
}

function Test-IsCurrentCompletionReferenceLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $true }
    $trimmed = $Line.Trim()
    if ($trimmed -match '^(>|`{3}|//|#)') { return $true }
    return $trimmed -match '(?i)(fixture|test string|test text|test case|expectedOutputRegex|forbiddenOutputRegex|regex|pattern|example|sample|quote|quoted|literal|引用|測試文字|測試字串|測試案例|說明文字|範例)'
}

function Remove-QuotedCompletionSegments {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return '' }
    $completionTermPattern = '(?:complete|completed|done|passed|ready|all\s+set|' +
        [regex]::Escape((New-UnicodeString -Codes @(0x5DF2, 0x5B8C, 0x6210))) + '|' +
        [regex]::Escape((New-UnicodeString -Codes @(0x5B8C, 0x6210))) + '|' +
        [regex]::Escape((New-UnicodeString -Codes @(0x901A, 0x904E))) + '|' +
        [regex]::Escape((New-UnicodeString -Codes @(0x53EF, 0x63D0, 0x4EA4))) + ')'
    $sanitized = [regex]::Replace($Line, '"[^"\r\n]*' + $completionTermPattern + '[^"\r\n]*"', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $sanitized = [regex]::Replace($sanitized, "'[^'\r\n]*" + $completionTermPattern + "[^'\r\n]*'", ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $sanitized = [regex]::Replace($sanitized, '`[^`\r\n]*' + $completionTermPattern + '[^`\r\n]*`', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    return $sanitized
}

function Remove-NegatedCompletionSegments {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return '' }
    $sanitized = [regex]::Replace($Line, '\b(?:not|never|no|without)\b.{0,50}\b(?:complete|completed|done|ready|passed)\b', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $sanitized = [regex]::Replace($sanitized, '\b(?:cannot|can''t|do\s+not|don''t|must\s+not|should\s+not)\b.{0,80}\b(?:claim|declare|call|report|mark)?\b.{0,30}\b(?:complete|completed|done|ready|passed)\b', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $zhNegatedCompletionTerms = @(
        (New-UnicodeString -Codes @(0x672A, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x5C1A, 0x672A, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x4E0D, 0x5BA3, 0x7A31, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x4E0D, 0x80FD, 0x5BA3, 0x7A31, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x7121, 0x6CD5, 0x5BA3, 0x7A31, 0x5B8C, 0x6210))
    )
    foreach ($term in $zhNegatedCompletionTerms) {
        $sanitized = $sanitized.Replace($term, ' ')
    }
    return $sanitized
}

function Test-IsReadonlyReportOnlyLine {
    param([string]$Line)

    if ([string]::IsNullOrWhiteSpace($Line)) { return $false }
    $hasReadonlyReport = $Line -match '(?i)\b(read-only|readonly|search|searched|scan|scanned|inspection|inspect|lookup|report|findings|grep|rg)\b'
    $hasCompletionWord = $Line -match '(?i)(\bcomplete\b|\bcompleted\b|\bdone\b|\bpassed\b|all\s+set)'
    if (-not ($hasReadonlyReport -and $hasCompletionWord)) { return $false }

    $hasCompletionTarget = $Line -match '(?i)\b(Wave\s+\d+|Team-Native|implementation|source|change|changes|build|fix|commit|Doctor|Audit|validation|tests?|checks?|fixtures?)\b'
    if (-not $hasCompletionTarget) { return $true }

    $hasNegatedWorkTarget = $Line -match '(?i)\b(no|not|without|missing)\b.{0,50}\b(source|implementation|change|changes|commit|write|mutation)\b'
    $hasHighRiskPassClaim = $Line -match '(?i)\b(validation\s+passed|Doctor/Audit\s+passed|ready\s+(?:to|for)\s+commit|tests?\s+passed|checks?\s+passed|fixtures?\s+passed)\b'
    $hasHighRiskCompletionClaim = $Line -match '(?i)\b(Wave\s+\d+|Team-Native|source|implementation|change|changes|build|fix|commit|Doctor|Audit|validation|tests?|checks?|fixtures?)\b.{0,80}\b(complete|completed|done|passed|ready)\b'
    if ($hasHighRiskCompletionClaim) { return $false }
    return ($hasNegatedWorkTarget -and (-not $hasHighRiskPassClaim))
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
        '^\s*all\s+set\s*[.!]?\s*$',
        'Wave\s+\d+.{0,80}(complete|completed|done|passed|ready)',
        '\b(?:this|current|the)\s+(?:turn|task|work|implementation|fix|change)\s+is\s+(?:complete|completed|done|ready)\b',
        (New-UnicodeString -Codes @(0x5DF2, 0x5B8C, 0x6210)),
        ((New-UnicodeString -Codes @(0x6E2C, 0x8A66)) + '.{0,20}' + (New-UnicodeString -Codes @(0x901A, 0x904E))),
        ((New-UnicodeString -Codes @(0x6AA2, 0x67E5)) + '.{0,20}' + (New-UnicodeString -Codes @(0x901A, 0x904E))),
        ((New-UnicodeString -Codes @(0x9A57, 0x8B49)) + '.{0,20}' + (New-UnicodeString -Codes @(0x901A, 0x904E))),
        (New-UnicodeString -Codes @(0x672C, 0x8F2A, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x4FEE, 0x5FA9, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x8B8A, 0x66F4, 0x5DF2, 0x5B8C, 0x6210)),
        (New-UnicodeString -Codes @(0x9A57, 0x8B49, 0x901A, 0x904E)),
        (New-UnicodeString -Codes @(0x6E2C, 0x8A66, 0x901A, 0x904E)),
        (New-UnicodeString -Codes @(0x53EF, 0x63D0, 0x4EA4))
    )

    foreach ($line in @($Text -split "`r?`n")) {
        if (Test-IsCurrentCompletionReferenceLine -Line $line) { continue }
        $line = Remove-QuotedCompletionSegments -Line $line
        if (Test-IsReadonlyReportOnlyLine -Line $line) { continue }
        $line = Remove-NegatedCompletionSegments -Line $line
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
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

function Get-HookStructuredDeliveryRecords {
    param([object]$Value)

    $records = New-Object System.Collections.Generic.List[object]
    Add-HookObjectRecordValues -Value $Value -Records $records
    return @($records.ToArray())
}

function Test-HookStructuredDeliveryRecordPositive {
    param([object]$Record)

    if ($null -eq $Record) { return $false }
    if ($Record -is [string]) { return $false }

    $statusText = Get-HookRecordFieldValue -Record $Record -Names @(
        'delivery_artifact_status',
        'artifact_status',
        'delivery_status',
        'status',
        'state'
    )
    if ([string]::IsNullOrWhiteSpace($statusText)) { return $false }
    if ($statusText -match '(?i)\b(missing|without|absent|unavailable|not[-_ ]?returned|not[-_ ]?provided|blocked|unverified|draft|pending|failed|failure|none|null|unknown)\b') {
        return $false
    }
    if ($statusText -notmatch '(?i)\b(returned|present|provided|ready|complete|completed|validated|passed|available|recovered|delivered|accepted)\b') {
        return $false
    }

    $idText = Get-HookRecordFieldValue -Record $Record -Names @(
        'delivery_artifact_id',
        'artifact_id',
        'delivery_id',
        'id'
    )
    if ([string]::IsNullOrWhiteSpace($idText)) { return $false }
    if ($idText -match '(?i)\b(missing|none|null|unknown|unavailable)\b') { return $false }

    return $true
}

function Test-HookStructuredDeliveryRecordMatchesType {
    param(
        [object]$Record,
        [string]$ArtifactPattern
    )

    if (-not (Test-HookStructuredDeliveryRecordPositive -Record $Record)) { return $false }
    $typeText = Get-HookRecordFieldValue -Record $Record -Names @(
        'delivery_artifact_type',
        'artifact_type',
        'delivery_type',
        'type',
        'kind',
        'role_id'
    )
    $recordText = (@(Get-NamedStringLeafValues -Value $Record -Prefix 'delivery') -join "`n")
    return (($typeText -match $ArtifactPattern) -or ($recordText -match $ArtifactPattern))
}

function Test-HookStructuredDeliveryFieldPresent {
    param(
        [object]$Payload,
        [string[]]$FieldNames,
        [string]$ArtifactPattern
    )

    foreach ($fieldName in @($FieldNames)) {
        $value = Get-HookProperty -Object $Payload -Name $fieldName
        foreach ($record in @(Get-HookStructuredDeliveryRecords -Value $value)) {
            if (Test-HookStructuredDeliveryRecordPositive -Record $record) {
                return $true
            }
        }
    }

    $deliveryArtifacts = Get-HookProperty -Object $Payload -Name 'delivery_artifacts'
    foreach ($record in @(Get-HookStructuredDeliveryRecords -Value $deliveryArtifacts)) {
        if (Test-HookStructuredDeliveryRecordMatchesType -Record $record -ArtifactPattern $ArtifactPattern) {
            return $true
        }
    }

    return $false
}

function Test-HasStructuredFullDeliveryArtifactSet {
    param([object]$Payload)

    $hasImplementation = Test-HookStructuredDeliveryFieldPresent -Payload $Payload -FieldNames @('implementation_delivery', 'change_delivery') -ArtifactPattern '(?i)(implementation change delivery|change delivery|implementation)'
    $hasMemoryDocs = Test-HookStructuredDeliveryFieldPresent -Payload $Payload -FieldNames @('memory_docs_delivery', 'memory_delivery') -ArtifactPattern '(?i)(memory/docs delivery|memory delivery|memory-docs delivery|docs delivery|memory_docs|memory)'
    $hasReview = Test-HookStructuredDeliveryFieldPresent -Payload $Payload -FieldNames @('review_delivery') -ArtifactPattern '(?i)(review delivery|review)'
    $hasValidation = Test-HookStructuredDeliveryFieldPresent -Payload $Payload -FieldNames @('validation_delivery') -ArtifactPattern '(?i)(validation delivery|validation)'

    return ($hasImplementation -and $hasMemoryDocs -and $hasReview -and $hasValidation)
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
    $englishStatePattern = '(?i)\b(?:blocked|unverified|partial-evidence|closed-with-director-risk|not-complete|incomplete)\b'
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
        if (($line -match $englishPattern) -or ($hasZhKey -and ($hasZhState -or ($line -match $englishStatePattern)))) {
            return $true
        }
    }
    return $false
}

function Test-HasClosedWithDirectorRiskState {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $zhRiskClosed = (New-UnicodeString -Codes @(0x98A8, 0x96AA, 0x95DC, 0x9589))
    foreach ($line in @($Text -split "`r?`n")) {
        if (Test-IsCurrentCompletionReferenceLine -Line $line) { continue }
        if (Test-IsNegatedClosureStateLine -Line $line) { continue }
        if (($line -match '(?i)\bclosed-with-director-risk\b') -or $line.Contains($zhRiskClosed)) {
            return $true
        }
    }
    return $false
}

function Test-HasDirectorRiskCloseEvidence {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }

    $hasExplicitRiskCloseField = $Text -match '(?i)(director_risk_close_evidence|director_risk_close_authorization|risk_close_evidence|risk_closure_evidence)'
    $hasDirector = $Text -match '(?i)\bDirector\b'
    if (-not $hasDirector) {
        $hasDirector = $Text.Contains((New-UnicodeString -Codes @(0x7E3D, 0x76E3)))
    }

    $hasRiskClose = $Text -match '(?i)(closed-with-director-risk|risk[- ]?close|risk[- ]?closure|accepted\s+risk|explicitly\s+accepted|GO\s+RISK)'
    $zhRiskCloseTerms = @(
        (New-UnicodeString -Codes @(0x98A8, 0x96AA, 0x95DC, 0x9589)),
        (New-UnicodeString -Codes @(0x63A5, 0x53D7, 0x98A8, 0x96AA)),
        (New-UnicodeString -Codes @(0x9010, 0x6848, 0x95DC, 0x9589))
    )
    foreach ($term in $zhRiskCloseTerms) {
        if ($Text.Contains($term)) {
            $hasRiskClose = $true
            break
        }
    }

    $hasScope = $Text -match '(?i)(director_risk_close_scope|risk_close_scope|risk_close_target|authorization_scope|authorization_target|authorized_files|scope[- ]?bound|current\s+(task|phase|turn)|this\s+(task|phase|turn)|station_id|handoff_packet_id)'
    $zhScopeTerms = @(
        (New-UnicodeString -Codes @(0x7BC4, 0x570D)),
        (New-UnicodeString -Codes @(0x76EE, 0x6A19)),
        (New-UnicodeString -Codes @(0x672C, 0x6B21)),
        (New-UnicodeString -Codes @(0x7576, 0x524D))
    )
    foreach ($term in $zhScopeTerms) {
        if ($Text.Contains($term)) {
            $hasScope = $true
            break
        }
    }

    return ($hasExplicitRiskCloseField -and $hasDirector -and $hasRiskClose -and $hasScope)
}

function Test-HasPostBlockBypassAttempt {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return $false }
    $hasBlockReference = $Text -match '(?i)(hook|gate|guard|blocked|denied|permission|PreToolUse|authorization|tool_payload_evidence_gap|policy enforcement)'
    $zhBlockSignals = @(
        (New-UnicodeString -Codes @(0x9264, 0x5B50)),
        (New-UnicodeString -Codes @(0x9598, 0x9580)),
        (New-UnicodeString -Codes @(0x64CB, 0x4E0B)),
        (New-UnicodeString -Codes @(0x88AB, 0x64CB)),
        (New-UnicodeString -Codes @(0x963B, 0x64CB)),
        (New-UnicodeString -Codes @(0x6388, 0x6B0A))
    )
    foreach ($signal in $zhBlockSignals) {
        if ($Text.Contains($signal)) {
            $hasBlockReference = $true
            break
        }
    }

    $hasBypassIntent = $Text -match '(?i)(retry|try again|use another tool|switch tools|switch channel|different tool|work around|bypass|use transcript|historical transcript|prior message)'
    $hasToolBypassIntent = $Text -match '(?i)\b(use|try|retry|switch to|fall back to|fallback to|run|call)\b.{0,80}\b(shell redirect|git apply|apply_patch|Out-File|Set-Content)\b|\b(shell redirect|git apply|apply_patch|Out-File|Set-Content)\b.{0,80}\b(instead|to bypass|work around|after (?:the )?block)'
    $zhBypassSignals = @(
        (New-UnicodeString -Codes @(0x63DB, 0x5DE5, 0x5177)),
        (New-UnicodeString -Codes @(0x63DB, 0x901A, 0x9053)),
        (New-UnicodeString -Codes @(0x91CD, 0x8A66)),
        (New-UnicodeString -Codes @(0x7E5E, 0x904E)),
        (New-UnicodeString -Codes @(0x7E5E, 0x958B)),
        (New-UnicodeString -Codes @(0x7528, 0x5C0D, 0x8A71)),
        (New-UnicodeString -Codes @(0x7528, 0x6B77, 0x53F2))
    )
    foreach ($signal in $zhBypassSignals) {
        if ($Text.Contains($signal)) {
            $hasBypassIntent = $true
            break
        }
    }

    return ($hasBlockReference -and ($hasBypassIntent -or $hasToolBypassIntent))
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
    $parseReason = "Team-Native hook input was empty or not valid JSON; fail-closed governance events require current structured evidence before action: $parseError"
    switch ($eventName) {
        'PreToolUse' {
            Exit-Block -EventName 'PreToolUse' -Reason $parseReason
        }
        'PermissionRequest' {
            Exit-Block -EventName 'PermissionRequest' -Reason $parseReason
        }
        'Stop' {
            Exit-Block -EventName 'Stop' -Reason $parseReason
        }
        'UserPromptSubmit' {
            Exit-AllowWithContext -EventName 'UserPromptSubmit' -Message ("Team-Native hook input was not valid JSON; governance evidence is unverified and cannot authorize writes or completion claims: {0}" -f $parseError)
        }
        default {
            Exit-AllowWithSystemMessage -Message ("Team-Native hook input was not valid JSON; hook evidence is unverified: {0}" -f $parseError)
        }
    }
}

$actionText = Get-HookActionText -Payload $payload
$evidenceText = Get-CurrentStructuredEvidenceText -Payload $payload
$transcriptText = Get-HistoricalTranscriptReferenceText -Payload $payload
$hostVerifiedToolLayerEvidence = Get-HookHostVerifiedToolLayerEvidence
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
$hasStructuredTeamNativePayload = Test-HasStructuredTeamNativePayload -Payload $payload
$hasProtectedMutation = ($toolBehavior -eq 'protected-mutation')
$hasWriteCapableAction = ($toolBehavior -eq 'write-capable')
$hasReadOnlyCommand = (($toolBehavior -eq 'read-only') -or ($toolBehavior -eq 'broad-read'))
$hasBroadReadCommand = ($toolBehavior -eq 'broad-read')
$hasSpecialistDeepReadEvidence = Test-HasSpecialistDeepReadEvidence -Text $evidenceText
$hasProtectedAuthorizationEvidence = Test-HasProtectedAuthorizationEvidence -ActionText $actionText -EvidenceText $evidenceText -Payload $payload -HostVerifiedToolLayerEvidence $hostVerifiedToolLayerEvidence
$hasScopedWriteAuthorization = Test-HasScopedWriteAuthorization -Text $evidenceText
$hasActionWithinScopedWriteAuthorization = Test-ActionWithinScopedWriteAuthorization -ActionText $actionText -EvidenceText $evidenceText -RepoRoot $repoRoot
$hasHostVerifiedToolEnvelope = (($null -ne $hostVerifiedToolLayerEvidence) -and (@(Get-HookTrustedToolEnvelopeRecords -Payload $hostVerifiedToolLayerEvidence).Count -gt 0))
$hasHostVerifiedExecutionReceipt = (($null -ne $hostVerifiedToolLayerEvidence) -and (@(Get-HookTrustedExecutionReceiptRecords -Payload $hostVerifiedToolLayerEvidence).Count -gt 0))

switch ($eventName) {
    'UserPromptSubmit' {
        if ((Test-IsGovernancePrompt -Text $actionText) -and (-not $hasTeamNativeEvidence)) {
            Exit-AllowWithContext -EventName 'UserPromptSubmit' -Message 'Team-Native route hint: natural-language instructions are valid. Treat ordinary wording such as GO, continue, so what, or fix it as route intent; bind it to the current action, current visible plan or station, file set, command, authorization phase, and expiry before any write or protected action. Do not require the Director to say internal channel names. Governance-impact, coding, validation, review, memory, commit, release, and broad file work still require a Captain Team Board, station handoff, role identity, channel state, and recovered delivery artifacts before completion claims.'
        }
    }
    'PreToolUse' {
        if (($hasWriteCapableAction -or $hasProtectedMutation) -and (-not $hasStructuredTeamNativePayload)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Write or protected mutation requires current structured Team-Native payload fields. Transcript text and text-only team_native_trace are diagnostic only; record tool_payload_evidence_gap until board, station, handoff, role, specialist skill, requested channel, channel capability, and invocation status are available.'
        }
        if ($hasWriteCapableAction -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Write-capable tool requested before a complete Team-Native board, handoff, role identity, and channel state are visible.'
        }
        if ($hasWriteCapableAction -and (-not $hasActionWithinScopedWriteAuthorization)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Write-capable tool requires scoped write authorization evidence that matches every current target path.'
        }
        if ($hasProtectedMutation -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Protected mutation requested before Team-Native board or channel evidence is visible. Open or recover the formal station evidence first.'
        }
        if ($hasProtectedMutation -and (-not ($hasHostVerifiedToolEnvelope -and $hasHostVerifiedExecutionReceipt))) {
            Exit-Block -EventName 'PreToolUse' -Reason 'Protected mutation requires host/platform verified tool-layer envelope and execution receipt; tool-layer envelope/receipt was not provided by host/platform verified channel. Payload self-asserted issuer, signature, nonce, host_verified_*, trusted_issuer, tool_execution_envelope, or tool_execution_receipt fields cannot authorize protected mutation.'
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
        if (($hasWriteCapableAction -or $hasProtectedMutation) -and (-not $hasStructuredTeamNativePayload)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Write or protected mutation permission requires current structured Team-Native payload fields. Transcript text and text-only team_native_trace are diagnostic only; record tool_payload_evidence_gap until board, station, handoff, role, specialist skill, requested channel, channel capability, and invocation status are available.'
        }
        if ($hasWriteCapableAction -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Write-capable tool permission request lacks a complete Team-Native board, handoff, role identity, and channel state.'
        }
        if ($hasWriteCapableAction -and (-not $hasActionWithinScopedWriteAuthorization)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Write-capable permission request requires scoped write authorization evidence that matches every current target path.'
        }
        if ($hasProtectedMutation -and (-not $hasTeamNativeEvidence)) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Permission request lacks visible Team-Native board, role, channel, and authorization evidence for the protected mutation.'
        }
        if ($hasProtectedMutation -and (-not ($hasHostVerifiedToolEnvelope -and $hasHostVerifiedExecutionReceipt))) {
            Exit-Block -EventName 'PermissionRequest' -Reason 'Protected mutation permission requires host/platform verified tool-layer envelope and execution receipt; tool-layer envelope/receipt was not provided by host/platform verified channel. Payload self-asserted issuer, signature, nonce, host_verified_*, trusted_issuer, tool_execution_envelope, or tool_execution_receipt fields cannot authorize protected mutation.'
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
        if (Test-HasPostBlockBypassAttempt -Text $actionText) {
            Exit-Block -EventName 'Stop' -Reason 'A hook or policy block cannot be followed by retrying with another tool, switching channels, or using transcript text as substitute authorization. Report blocked or unverified with missing structured evidence instead.'
        }
        if ((Test-HasClosedWithDirectorRiskState -Text $currentText) -and (-not (Test-HasDirectorRiskCloseEvidence -Text $evidenceText))) {
            Exit-Block -EventName 'Stop' -Reason 'closed-with-director-risk requires current explicit scope-bound Director risk close evidence in structured payload fields; assistant text alone cannot close the risk.'
        }
        if ((Test-ClaimsCompletion -Text $actionText) -and (-not (Test-HasStructuredFullDeliveryArtifactSet -Payload $payload)) -and (-not (Test-HasNonCompleteClosureState -Text $currentText))) {
            Exit-Block -EventName 'Stop' -Reason 'Completion claim requires structured, recovered implementation, memory/docs, review, and validation delivery artifacts with returned status or an explicit blocked/unverified/closed-with-director-risk state.'
        }
    }
}

exit 0
