$ErrorActionPreference = 'Stop'

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $utf8NoBom
$OutputEncoding = $utf8NoBom

function ConvertFrom-HookBase64 {
    param([string]$Value)
    return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

function Get-HookMessage {
    param([string]$Key)
    $messages = @{
        SessionStartupContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrnpoHmraLpmorplbfnm7TmjqXnlKLnlJ8gYnJvYWQgcmVhZCAvIHZhbGlkYXRpb24gLyByZXZpZXcgLyBleHRlcm5hbCByZXNlYXJjaCAvIG1lbW9yeS1kb2NzIC8gY29tcGxldGlvbiBldmlkZW5jZeOAguWFgeiosemaiumVt+WBmiBjb29yZGluYXRpb27jgIFzdGF0aW9uIGRpc3BhdGNo44CBYXJ0aWZhY3Qgc3ludGhlc2lz44CBbmFtZWQtZmlsZSBsb2NhbF9wcm9iZeOAgmRpcmVjdF9leGNlcHRpb24g5Y+q6IO96ZmN57Sa5oiQIHBhcnRpYWwgLyB1bnZlcmlmaWVkIC8gY2xvc2VkLXdpdGgtZGlyZWN0b3Itcmlza++8jOS4jeWPr+Wuo+eosSBjb21wbGV0ZeOAgmV4dGVybmFsIHJlc2VhcmNoIOW/hemgiOeUsSBmb3JtYWwgZXh0ZXJuYWwtcmVzZWFyY2ggc3RhdGlvbiDnlKLnlJ8gZXh0ZXJuYWxfcmVzZWFyY2hfYXJ0aWZhY3RfaWTvvJvmspLmnIkgYXJ0aWZhY3Qg5bCx5Y+q6IO9IHVudmVyaWZpZWQvcGFydGlhbC9ibG9ja2Vk44CC'
        SessionOtherSourceContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrmraQgU2Vzc2lvblN0YXJ0IOS+hua6kOS4jeaYryBzdGFydHVwL3Jlc3VtZe+8m+ebruWJjSBob29rcy5qc29uIOaHieWPquWMuemFjSBzdGFydHVwL3Jlc3VtZeOAguemgeatouaKiuatpOaPkOmGkueVtuS9nOermem7nuitieaTmuaIluWujOaIkOitieaTmuOAgg=='
        SessionSystemMessage = '5ZyY6ZqK5qih5byP5o+Q6YaS77ya56aB5q2i6ZqK6ZW355u05o6l55Si55SfIGJyb2FkIHJlYWQgLyB2YWxpZGF0aW9uIC8gcmV2aWV3IC8gZXh0ZXJuYWwgcmVzZWFyY2ggLyBtZW1vcnktZG9jcyAvIGNvbXBsZXRpb24gZXZpZGVuY2XjgILlhYHoqLEgY29vcmRpbmF0aW9u44CBc3RhdGlvbiBkaXNwYXRjaOOAgWFydGlmYWN0IHN5bnRoZXNpc+OAgW5hbWVkLWZpbGUgbG9jYWxfcHJvYmXvvJtkaXJlY3RfZXhjZXB0aW9uIOS4jeWPr+Wuo+eosSBjb21wbGV0ZeOAgg=='
        PreToolContextFormat = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrmj5DphpLmqKHlvI/vvIzkuI3mnIPpmLvmk4vlt6XlhbfjgILnpoHmraLpmorplbfnm7TmjqXnlKLnlJ8gYnJvYWQgcmVhZCAvIHZhbGlkYXRpb24gLyByZXZpZXcgLyBleHRlcm5hbCByZXNlYXJjaCAvIG1lbW9yeS1kb2NzIC8gY29tcGxldGlvbiBldmlkZW5jZeOAguWFgeiosemaiumVt+WBmiBjb29yZGluYXRpb27jgIFzdGF0aW9uIGRpc3BhdGNo44CBYXJ0aWZhY3Qgc3ludGhlc2lz44CBbmFtZWQtZmlsZSBsb2NhbF9wcm9iZeOAguiLpeS4jeaYryBuYW1lZC1maWxlIGxvY2FsX3Byb2Jl77yM6KuL5YWI5YGc5q2i6YCZ5qyh5bel5YW35ZG85Y+r5Lim5pS55rS+56uZ6bue5oiW6ZmN57Sa44CCZGlyZWN0X2V4Y2VwdGlvbiDlj6rog73pmY3ntJrmiJAgcGFydGlhbCAvIHVudmVyaWZpZWQgLyBjbG9zZWQtd2l0aC1kaXJlY3Rvci1yaXNr77yM5LiN5Y+v5a6j56ixIGNvbXBsZXRl44CCZXh0ZXJuYWwgcmVzZWFyY2gg5b+F6aCI55SxIGZvcm1hbCBleHRlcm5hbC1yZXNlYXJjaCBzdGF0aW9uIOeUoueUnyBleHRlcm5hbF9yZXNlYXJjaF9hcnRpZmFjdF9pZO+8m+aykuaciSBhcnRpZmFjdCDlsLHlj6rog70gdW52ZXJpZmllZC9wYXJ0aWFsL2Jsb2NrZWTjgILlt6XlhbfliIbpoZ7vvJp7MH3jgII='
        PreToolSystemMessage = '5o+Q6YaS5qih5byP77yM5LiN5pyD6Zi75pOL5bel5YW344CC56aB5q2i5LqL6aCF77ya6ZqK6ZW35LiN5b6X55u05o6l5pu/6ZqK5ZOh5a6M5oiQIGJyb2FkIHJlYWQgLyB2YWxpZGF0aW9uIC8gcmV2aWV3IC8gZXh0ZXJuYWwgcmVzZWFyY2ggLyBtZW1vcnktZG9jcyAvIGNvbXBsZXRpb24gZXZpZGVuY2XjgILlhYHoqLHkuovpoIXvvJpjb29yZGluYXRpb27jgIFzdGF0aW9uIGRpc3BhdGNo44CBYXJ0aWZhY3Qgc3ludGhlc2lz44CBbmFtZWQtZmlsZSBsb2NhbF9wcm9iZeOAgumZjee0muW+jOaenO+8mmRpcmVjdF9leGNlcHRpb24g5Y+q6IO9IHBhcnRpYWwgLyB1bnZlcmlmaWVkIC8gY2xvc2VkLXdpdGgtZGlyZWN0b3Itcmlza++8jOS4jeWPryBjb21wbGV0ZeOAgg=='
        PreToolDenyRepoScanReason = '5bey6Zi75pOL5YWoIHJlcG8g5o6D5o+P44CC56aB5q2i6ZqK6ZW355SoIHJnIC0tZmlsZXMg5oiWIGdpdCBscy1maWxlcyDnm7TmjqXnlKLnlJ8gcmVwbyBpbnZlbnRvcnkgZXZpZGVuY2XvvJvoq4vlhYjmtL7nq5npu57miJbmlLnnlKjlkb3lkI3mqpQv56qE56+E5ZyN6K6A5Y+W44CC'
        PreToolDenyGuardedNoStationReason = '5bey6Zi75pOL57y65bCR56uZ6bue55eV6Leh55qEIGd1YXJkZWQgZGlyZWN0IGFjdGlvbuOAguiri+WFiOa0vuermem7nuaIlumZhOS4iiBzdGF0aW9uIHRyYWNl77yM5oiW5pS555SoIG5hbWVkLWZpbGUgbG9jYWxfcHJvYmXjgII='
        BadInputReason = '6Ly45YWl5LiN5piv5pyJ5pWIIEpTT07vvJtiYWQtaW5wdXQgc21va2XjgILnpoHmraLmiornhKHmlYggcGF5bG9hZCDnlbbmiJDnq5npu57orYnmk5rvvJvlj6rlhYHoqLEgaG9zdCDnubznuozkuKbkv53nlZkgYWR2aXNvcnkvcmVtaW5kZXLjgII='
        UnknownEventReasonFormat = '55uu5YmN5LqL5Lu25pyq5o6b5rex5bGkIGdhdGXvvJp7MH3jgILnpoHmraLmiormnKrnn6Xkuovku7bovLjlh7rnlbbkvZzlrozmiJDorYnmk5rjgII='
        StopNonCompleteAllowedSystemMessage = '5a6M5oiQ6ZaY6ZaA5o+Q6YaS77ya5Zue6KaG5bey5L2/55SoIGJsb2NrZWQgLyB1bnZlcmlmaWVkIC8gY2xvc2VkLXdpdGgtZGlyZWN0b3ItcmlzayAvIHBhcnRpYWwg562J6Z2e5a6M5oiQ54uA5oWL77yb5YWB6Kix6YCB5Ye677yM5L2G5LiN5Y+v5a6j56ixIGNvbXBsZXRl44CC'
        StopCompleteAllowedSystemMessage = '5a6M5oiQ6ZaY6ZaA5o+Q6YaS77ya5bey5YG15ris5Yiw56uZ6bue5Lqk5LuY6Y+I6IiHIGNvbXBsZXRpb24gYXVkaXTvvJvlhYHoqLHpgIHlh7rlrozmlbTlrozmiJDlrqPnqLHjgII='
        StopRiskAdvisorySystemMessage = '5a6M5oiQ6ZaY6ZaA5o+Q6YaS77ya5YG15ris5Yiw5a6M5oiQ5a6j56ix5Y+v6IO957y65bCR56uZ6bue6K2J5pOa5oiW54uA5oWL6KGd56qB77yb5pysIGhvb2sg5LiN5pyD6Zi75pOL6YCB5Ye677yM6KuL55Sx57i955uj5Yik5pa35piv5ZCm5o6l5Y+X44CCUmVhc29uIGNvZGU6IHswfS4gTWlzc2luZyBzdHJ1Y3R1cmVkIGZpZWxkczogezF9LiDlu7rorbDmqJnmmI4gcGFydGlhbCAvIHVudmVyaWZpZWQgLyBibG9ja2VkIC8gY2xvc2VkLXdpdGgtZGlyZWN0b3ItcmlzayDmiJboo5zpvYogc3RhdGlvbi1vd25lZCBhcnRpZmFjdHPjgII='
        UserPromptTeamModePhrase = '5pON5L2c6ICF6KaB5rGC6ZaL5ZWf5a2Q5Luj55CG5Yqf6IO977yM5Lim6buY6KqN5ZWf5YuV5ZyY6ZqK5qih5byP'
        UserPromptSystemMessage = '5pys6Lyq5ZyY6ZqK5o6I5qyK5o+Q6YaS77yac3ViYWdlbnRzIOWPquiDveWcqOacrOi8quaYjueiuuaOiOasiuaIluaXouaciSBzY29wZWQgVGVhbS1OYXRpdmUg5o6I5qyK5LiL5L2/55So44CC'
        SubagentStartSystemMessage = '5a2Q5Luj55CG6YKK55WM5o+Q6YaS77ya5LiN5b6X6YGe6L+05aeU5rS+44CB5LiN5b6X54Sh55WM5a+r5YWl44CB6aCQ6Kit5ZSv6K6A44CB5LiN5b6X6Ieq6KGM5a6j56ix5a6M5oiQ44CC'
        SubagentStopBlockedSystemMessage = '5a2Q5Luj55CG5Lqk5LuY5o+Q6YaS77ya57y65bCR5pGY6KaB44CB6K2J5pOa44CB6aKo6Zqq5oiW5LiL5LiA5q2l5pmC5b+F6aCI6KOc6b2K44CC'
        SubagentStopAllowedSystemMessage = '5a2Q5Luj55CG5Lqk5LuY5o+Q6YaS77ya5pGY6KaB44CB6K2J5pOa44CB6aKo6Zqq6IiH5LiL5LiA5q2l5bey5a2Y5Zyo44CC'
    }
    return ConvertFrom-HookBase64 -Value $messages[$Key]
}

function Get-HookPropertyValue {
    param([object]$Object, [string[]]$Names)
    if ($null -eq $Object) { return $null }
    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties[$name]
        if ($null -ne $property) { return $property.Value }
    }
    return $null
}

function ConvertTo-HookText {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    if ($Value -is [string]) { return $Value }
    return ($Value | ConvertTo-Json -Depth 32 -Compress)
}

function Add-HookTextPart {
    param([System.Collections.Generic.List[string]]$Parts, [object]$Value)
    if ($null -ne $Value -and [string]$Value -ne '') {
        $Parts.Add((ConvertTo-HookText -Value $Value))
    }
}

function Add-HookCommandCandidatesFromObject {
    param([object]$Object, [System.Collections.Generic.List[string]]$Candidates, [int]$Depth)
    if ($null -eq $Object -or $Depth -lt 0) { return }
    foreach ($name in @('command','cmd','script')) {
        Add-HookTextPart -Parts $Candidates -Value (Get-HookPropertyValue -Object $Object -Names @($name))
    }
    foreach ($name in @('tool_input','toolInput','input','payload','arguments','args','params')) {
        $nested = Get-HookPropertyValue -Object $Object -Names @($name)
        if ($null -eq $nested -or $nested -is [string] -or [object]::ReferenceEquals($nested, $Object)) { continue }
        Add-HookCommandCandidatesFromObject -Object $nested -Candidates $Candidates -Depth ($Depth - 1)
    }
}

function Get-HookCommandCandidates {
    param([object]$Payload)
    $candidates = New-Object System.Collections.Generic.List[string]
    Add-HookCommandCandidatesFromObject -Object $Payload -Candidates $candidates -Depth 4
    return @($candidates.ToArray())
}

function Add-HookActionTextPartsFromObject {
    param([object]$Object, [System.Collections.Generic.List[string]]$Parts, [int]$Depth, [switch]$IncludeToolName)
    if ($null -eq $Object -or $Depth -lt 0) { return }
    $fieldNames = @('command','cmd','script','action','target','path','file_path','patch','prompt','last_assistant_message','message','text','raw_text')
    if ($IncludeToolName) { $fieldNames = @('tool_name') + $fieldNames }
    foreach ($name in $fieldNames) {
        Add-HookTextPart -Parts $Parts -Value (Get-HookPropertyValue -Object $Object -Names @($name))
    }
    foreach ($name in @('tool_input','toolInput','input','payload','arguments','args','params')) {
        $nested = Get-HookPropertyValue -Object $Object -Names @($name)
        if ($null -eq $nested -or $nested -is [string] -or [object]::ReferenceEquals($nested, $Object)) { continue }
        Add-HookActionTextPartsFromObject -Object $nested -Parts $Parts -Depth ($Depth - 1)
    }
}

function Add-HookEventMarker {
    param([string]$EventName, [string]$Context)
    $marker = "AI_RULES_HOOK_EVENT=$EventName"
    if ([string]::IsNullOrWhiteSpace($Context)) { return $marker }
    if ($Context -match [regex]::Escape($marker)) { return $Context }
    return ("{0}`n{1}" -f $marker, $Context)
}

function Get-HookActionText {
    param([object]$Payload)
    $parts = New-Object System.Collections.Generic.List[string]
    Add-HookActionTextPartsFromObject -Object $Payload -Parts $parts -Depth 4 -IncludeToolName
    return (($parts -join "`n").Trim())
}

function Get-HookTranscriptText {
    param([object]$Payload)
    # Trace bridge example: station_mode: formal-write; handoff_ownership: station-owned; authorization_phase: implementation-change-delivery.
    $path = [string](Get-HookPropertyValue -Object $Payload -Names @('transcript_path','transcriptPath'))
    if ([string]::IsNullOrWhiteSpace($path)) { return '' }
    try {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return '' }
        $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        if ($null -eq $text) { return '' }
        if ($text.Length -gt 20000) { return $text.Substring($text.Length - 20000) }
        return $text
    } catch {
        return ''
    }
}

function Get-HookExecutableCommand {
    param([object]$Payload)
    $candidates = @(Get-HookCommandCandidates -Payload $Payload)
    if ($candidates.Count -eq 0) { return '' }
    return ([string]$candidates[$candidates.Count - 1]).Trim()
}

function Test-HookAllowedOuterAgent {
    param([object]$Payload)
    $agentId = [string](Get-HookPropertyValue -Object $Payload -Names @('agent_id'))
    # Host agent_type is optional and may be default/explorer/worker or another host value.
    # Only the outer host payload is trusted; tool_input metadata is intentionally ignored.
    if ([string]::IsNullOrWhiteSpace($agentId)) { return $false }
    return $true
}

function Test-HookExactInventoryCommand {
    param([string]$Command)
    if (-not $Command) { return $false }
    $inventoryCommandPatterns = @('rg --files','rg.exe --files','git ls-files','git.exe ls-files')
    return ($inventoryCommandPatterns -ccontains $Command.Trim())
}

function Test-HookHasStationTrace {
    param([object]$Payload, [string]$Text)
    $metadataHits = 0
    foreach ($name in @(
        'station_mode','stationMode',
        'authorization_phase','authorizationPhase',
        'handoff_ownership','handoffOwnership',
        'role_id','roleId',
        'author_role','authorRole',
        'assigned_specialist','assignedSpecialist',
        'delivery_artifact_id','deliveryArtifactId',
        'board','Board'
    )) {
        $value = Get-HookPropertyValue -Object $Payload -Names @($name)
        if ($null -ne $value -and [string]$value -ne '') { $metadataHits++ }
    }
    if ($metadataHits -ge 2) { return $true }
    if (-not $Text) { return $false }

    $traceHits = 0
    $hasStationMode = ($Text -match '(?i)\bstation_mode\s*[:=]\s*(formal-write|formal-readonly|change-delivery|change-application|readonly|read-only)\b')
    $hasOwnership = ($Text -match '(?i)\bhandoff_ownership\s*[:=]\s*(station-owned|implementation patch|change-delivery|change-application)\b')
    $hasPhase = ($Text -match '(?i)\bauthorization_phase\s*[:=]\s*(implementation-change-delivery|change-application|formal-readonly|formal-write)\b')
    $hasRole = ($Text -match '(?i)\b(author_role|role_id|assigned_specialist|Board)\s*[:=]')
    $hasBoundedScope = ($Text -match '(?i)\bexact file allowlist\b|\bdirty-diff read\b|\bstation-owned\b|\bchange-delivery\b|\bchange-application\b')
    foreach ($hit in @($hasStationMode, $hasOwnership, $hasPhase, $hasRole, $hasBoundedScope)) {
        if ($hit) { $traceHits++ }
    }
    return (($hasStationMode -or $hasOwnership -or $hasPhase) -and $traceHits -ge 2)
}

function Test-HookDeniedRepoScan {
    param([object]$Payload, [string]$Text)
    if (-not $Text) { return $false }

    $toolName = [string](Get-HookPropertyValue -Object $Payload -Names @('tool_name'))
    $command = Get-HookExecutableCommand -Payload $Payload
    $looksExecutable = ($command -ne '') -or ($toolName -match '(Bash|Shell|PowerShell|pwsh|cmd|exec_command|terminal)')
    if (-not $looksExecutable) { return $false }

    if ((Test-HookAllowedOuterAgent -Payload $Payload) -and (Test-HookExactInventoryCommand -Command $command)) {
        return $false
    }

    foreach ($pattern in @(
        '(?m)(^|[;&|]\s*)\s*rg(\.exe)?\s+--files(?=\s|[;&|>]|$)',
        '(?m)(^|[;&|]\s*)\s*git(\.exe)?\s+ls-files(?=\s|[;&|>]|$)'
    )) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Test-HookBroadRead {
    param([string]$Text)
    if (-not $Text) { return $false }
    foreach ($pattern in @(
        'rg\s+--files',
        'git(\.exe)?\s+ls-files',
        'Get-ChildItem\b[\s\S]*\b-Recurse\b',
        'Get-Content\b[\s\S]*\b-Recurse\b',
        '(^|\s)rg\s+\S+\s*$'
    )) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Test-HookWriteLike {
    param([object]$Payload, [string]$Text)
    $toolName = [string](Get-HookPropertyValue -Object $Payload -Names @('tool_name'))
    if ($toolName -match '^(apply_patch|Edit|Write)$') { return $true }
    if (-not $Text) { return $false }
    foreach ($pattern in @(
        'apply_patch',
        'Set-Content|Add-Content|Out-File|New-Item|Copy-Item|Move-Item|Remove-Item',
        '(^|[^-])>\s*[^&\s]',
        '>>\s*[^&\s]',
        '\bsed\s+-i\b',
        '\btee\b',
        'git\s+apply\b',
        '\bnpm\s+install\b|\bpnpm\s+install\b|\byarn\s+add\b|\bpip\s+install\b'
    )) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Test-HookReadOnly {
    param([string]$Text)
    if (-not $Text) { return $false }
    foreach ($pattern in @(
        '(^|\s)(rg|grep|findstr)\s',
        '(^|\s)(Get-Content|gc|type|cat)\s',
        '(^|\s)(Get-ChildItem|dir|ls)\s',
        '(^|\s)git\s+(diff|show|status|rev-parse|log)\b',
        '(^|\s)(Select-String|Measure-Object)\b'
    )) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Test-HookGuardedDirectActionWithoutStationTrace {
    param([object]$Payload, [string]$Text)
    # Existing outer-agent inventory exception remains before station_mode: formal-write; handoff_ownership: station-owned; authorization_phase: implementation-change-delivery trace checks.
    $command = Get-HookExecutableCommand -Payload $Payload
    if ((Test-HookAllowedOuterAgent -Payload $Payload) -and (Test-HookExactInventoryCommand -Command $command)) {
        return $false
    }
    $traceText = $Text
    $transcriptText = Get-HookTranscriptText -Payload $Payload
    if ($transcriptText) { $traceText = "$traceText`n$transcriptText" }
    if (Test-HookHasStationTrace -Payload $Payload -Text $traceText) { return $false }
    if (Test-HookBroadRead -Text $Text) { return $true }
    if (Test-HookWriteLike -Payload $Payload -Text $Text) { return $true }
    return $false
}

function Get-HookToolClass {
    param([object]$Payload)
    $actionText = Get-HookActionText -Payload $Payload
    if (Test-HookBroadRead -Text $actionText) { return 'broad-read' }
    if (Test-HookWriteLike -Payload $Payload -Text $actionText) { return 'write-advisory' }
    if (Test-HookReadOnly -Text $actionText) { return 'single-file-readonly' }
    return 'general-tool'
}

function Write-HookJson {
    param([object]$Body)
    $Body | ConvertTo-Json -Depth 32 -Compress
}

function Write-SessionStartReminder {
    param([object]$Payload)
    $source = [string](Get-HookPropertyValue -Object $Payload -Names @('source'))
    $context = Get-HookMessage -Key 'SessionStartupContext'
    if ($source -and (@('startup','resume') -notcontains $source)) {
        $context = Get-HookMessage -Key 'SessionOtherSourceContext'
    }
    $context = Add-HookEventMarker -EventName 'SessionStart' -Context $context
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'SessionSystemMessage')
        hookSpecificOutput = [ordered]@{
            hookEventName = 'SessionStart'
            additionalContext = $context
        }
    })
}

function Write-UserPromptSubmitReminder {
    $context = 'Project policy permits bounded subagents only when the current Director prompt explicitly requests team, subagent, delegation, or governed multi-station work, or when an active governed task already carries scoped Team-Native authorization. For broad, read-heavy, multi-area, audit, review, debugging, or exploration tasks, prefer bounded subagents within the configured agents.max_threads limit and Codex default depth. Default subagent work is read-only. Main-worktree edits are allowed only when the current task explicitly authorizes file changes and the subagent is assigned as a station-owned change-delivery or change-application route with formal-write authorization, an exact file allowlist, and dirty-diff read. If runtime policy still requires per-turn explicit subagent authorization and the current prompt does not provide it, stop and ask for one-line Director confirmation instead of silently falling back to single-agent work.'
    $stateLines = @(
        (Get-HookMessage -Key 'UserPromptTeamModePhrase'),
        'TEAM_NATIVE_ACTIVE=true',
        'SUBAGENT_AUTHORIZATION=granted_for_bounded_stations',
        'LANE_SELECTION=exclusion_first_negative_contract',
        'CAPTAIN_DIRECT_WORK=forbidden_except_named_file_local_probe_or_recorded_exception',
        'NEXT_LEGAL_ACTION=dispatch_matching_station_or_stop_noncomplete'
    )
    $context = ((@($stateLines) + @($context)) -join "`n")
    $context = Add-HookEventMarker -EventName 'UserPromptSubmit' -Context $context
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'UserPromptSystemMessage')
        hookSpecificOutput = [ordered]@{
            hookEventName = 'UserPromptSubmit'
            additionalContext = $context
        }
    })
}

function Write-SubagentStartReminder {
    $context = 'Subagent boundary: do not recursively delegate; default to read-only unless assigned as station-owned change-delivery or change-application with formal-write authorization, an exact file allowlist, and dirty-diff read; then main-worktree edits are allowed only within that allowlist; do not take protected actions such as memory, git, release, deploy, install, credentials, or external mutation unless a scoped protected station explicitly owns that phase; do not claim overall task completion or final Director-facing completion; report only assigned station/subtask status and artifact; return summary, evidence, risk, and next steps for parent routing.'
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'SubagentStartSystemMessage')
        hookSpecificOutput = [ordered]@{
            hookEventName = 'SubagentStart'
            additionalContext = $context
        }
    })
}

function Write-PreToolUseDeny {
    param([string]$MessageKey = 'PreToolDenyRepoScanReason')
    $reason = Get-HookMessage -Key $MessageKey
    if ($MessageKey -eq 'PreToolDenyGuardedNoStationReason') {
        $reason = "$reason`nGUARDED_DIRECT_ACTION_NO_STATION_TRACE=true"
    }
    Write-HookJson -Body ([ordered]@{
        systemMessage = $reason
        hookSpecificOutput = [ordered]@{
            hookEventName = 'PreToolUse'
            permissionDecision = 'deny'
            permissionDecisionReason = $reason
        }
    })
}

function Write-PreToolUseReminder {
    param([object]$Payload, [string]$Reason)
    $actionText = Get-HookActionText -Payload $Payload
    if (Test-HookDeniedRepoScan -Payload $Payload -Text $actionText) {
        Write-PreToolUseDeny
        return
    }
    if (Test-HookGuardedDirectActionWithoutStationTrace -Payload $Payload -Text $actionText) {
        Write-PreToolUseDeny -MessageKey 'PreToolDenyGuardedNoStationReason'
        return
    }
    $toolClass = Get-HookToolClass -Payload $Payload
    $context = (Get-HookMessage -Key 'PreToolContextFormat') -f $toolClass
    if ($Reason) { $context = "$context $Reason" }
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'PreToolSystemMessage')
        hookSpecificOutput = [ordered]@{
            hookEventName = 'PreToolUse'
            additionalContext = $context
        }
    })
}

function Test-HookHasNonCompleteState {
    param([string]$Text)
    if (-not $Text) { return $false }
    $searchText = Remove-HookStopClassificationNoise -Text $Text
    return ($searchText -match '(?i)\b(blocked|unverified|closed-with-director-risk|partial)\b|\u672A\u9A57\u8B49|\u53D7\u963B|\u963B\u585E|\u90E8\u5206\u5B8C\u6210|\u98A8\u96AA\u95DC\u9589')
}

function Remove-HookStopClassificationNoise {
    param([string]$Text)
    if (-not $Text) { return '' }
    $clean = $Text
    foreach ($pattern in @(
        '(?is)<hook_prompt\b[^>]*>.*?</hook_prompt>',
        '(?is)\{?\s*"decision"\s*:\s*"block"\s*,\s*"reason"\s*:\s*"[^"]*(?:TN-HOOK-[^"]*)?[^"]*"\s*\}?',
        '(?is)Stop gate blocked\..{0,600}?substitute evidence\.',
        '(?is)\u5B8C\u6210\u9598\u9580\u5DF2\u963B\u64CB.{0,1400}?(?:Forbidden next steps:[^\r\n]*)?',
        '(?im)^\s*>?\s*(?:Governance reminder only|Block type:|Reason code:|Missing structured fields:|Allowed next steps|Forbidden next steps)\s*:.*$',
        '(?im)^\s*>?\s*(?:Stop gate blocked|advisory/reminder|\u5B8C\u6210\u9598\u9580|\u7981\u6B62\u4E8B\u9805)\b.*$',
        '(?i)\b(?:[A-Za-z]:)?[A-Za-z0-9_./\\:-]*(?:allow|block)-stop-[A-Za-z0-9_.-]*\.json\b',
        '(?i)\bScripts[\\/]+tests[\\/]+codex-hooks[\\/]+fixtures[\\/]+[A-Za-z0-9_.-]+\.json\b',
        '(?i)\bnon[-\s]?complete\b',
        '(?i)\bnot[-\s]?complete\b',
        '(?i)\bcompletion\s+claim\b'
    )) {
        $clean = [regex]::Replace($clean, $pattern, ' ')
    }
    return $clean
}

function Remove-HookNegatedCompletionReference {
    param([string]$Text)
    if (-not $Text) { return '' }
    $clean = Remove-HookStopClassificationNoise -Text $Text
    foreach ($pattern in @(
        '(?is)(?:\u4E0D(?:\u53EF|\u80FD|\u6703)?|\u4E0D\u8981|\u672A|\u4E26\u672A|\u4E0D\u6703)\s*(?:\u5BA3\u7A31|\u8072\u7A31|\u8868\u793A|\u8996\u70BA)?\s*(?:full\s+)?complete',
        '(?is)(?:\u4E0D\u80FD|\u4E0D\u53EF|\u4E0D\u5F97|\u4E0D\u8981|\u4E0D\u61C9|\u4E0D\u8A72|\u7981\u6B62|\u907F\u514D|\u8ACB\u52FF).{0,120}(?:complete|completed|done|finished|all set|\u5B8C\u6210|\u5B8C\u6210\u4E86|\u5168\u90E8\u5B8C\u6210|\u5B8C\u6210\u5BA3\u7A31|\u6536\u5C3E)',
        '(?is)(?:must\s+not|do\s+not|cannot|can\s+not|not)\s+(?:claim\s+)?(?:full\s+)?complete',
        '(?is)(?:must\s+not|do\s+not|cannot|can\s+not|should\s+not|mustn''t|don''t|avoid|forbid(?:den)?|never).{0,120}(?:final\s+success|successful\s+final|successfully\s+finished)',
        '(?is)(?:must\s+not|do\s+not|cannot|can\s+not|should\s+not|mustn''t|don''t|avoid|forbid(?:den)?|never).{0,120}(?:completion_state\s*[:=]\s*complete|complete|completed|done|finished|all set)',
        '(?is)\bnot\s+(?:yet\s+)?complete\b',
        '(?is)\bno\s+completion\s+claim\b'
    )) {
        $clean = [regex]::Replace($clean, $pattern, ' ')
    }
    return $clean
}

function Test-HookHasCompletionClaim {
    param([string]$Text)
    if (-not $Text) { return $false }
    $searchText = Remove-HookNegatedCompletionReference -Text $Text
    return ($searchText -match '(?i)\bcompletion_state\s*[:=]\s*complete\b|\b(complete|completed|done|finished|all set|final success|successful final)\b|\u5DF2\u5B8C\u6210|\u5B8C\u6210\u4E86|\u5168\u90E8\u5B8C\u6210|\u53EF\u4EE5\u6536\u5C3E|\u53EF\u6536\u5C3E|(?:\u4F46|\u73FE\u5728|\u76EE\u524D|\u4EFB\u52D9|\u5DE5\u4F5C|\u4FEE\u6539).{0,8}\u5B8C\u6210')
}

function Test-HookStopHookActiveFromObject {
    param([object]$Object, [int]$Depth)
    if ($null -eq $Object -or $Depth -lt 0) { return $false }
    $flag = Get-HookPropertyValue -Object $Object -Names @('stop_hook_active','stopHookActive')
    if ($null -ne $flag) {
        if ($flag -is [bool]) { return [bool]$flag }
        if ([string]$flag -match '^(?i:true|1|yes)$') { return $true }
    }
    foreach ($name in @('tool_input','toolInput','input','payload','arguments','args','params')) {
        $nested = Get-HookPropertyValue -Object $Object -Names @($name)
        if ($null -eq $nested -or $nested -is [string] -or [object]::ReferenceEquals($nested, $Object)) { continue }
        if (Test-HookStopHookActiveFromObject -Object $nested -Depth ($Depth - 1)) { return $true }
    }
    return $false
}

function Test-HookStopFeedbackEcho {
    param([string]$Text)
    if (-not $Text) { return $false }
    return ($Text -match '(?is)\bTN-HOOK-[A-Z0-9-]+\b|Stop gate blocked\.|\u5B8C\u6210\u9598\u9580\u5DF2\u963B\u64CB|"decision"\s*:\s*"block"|Reason code:|Missing structured fields:|Allowed next steps|Forbidden next steps|Governance reminder only|Block type:')
}

function Test-HookStopActiveNonClaimEcho {
    param([object]$Payload, [string]$RawText, [string]$ClassifiedText)
    if (-not (Test-HookStopHookActiveFromObject -Object $Payload -Depth 4)) { return $false }
    if (-not (Test-HookStopFeedbackEcho -Text $RawText)) { return $false }
    return (-not (Test-HookHasCompletionClaim -Text $ClassifiedText))
}

function Test-HookHasStationCompletionEvidence {
    param([string]$Text)
    if (-not $Text) { return $false }
    if (Test-HookHasNegatedStationCompletionEvidence -Text $Text) { return $false }
    $requiredPatterns = @(
        'delivery_artifact_id|change delivery artifact|change-delivery',
        'validation_state\s*[:=]\s*(passed|accepted)|validation.*(passed|artifact)',
        'review_state\s*[:=]\s*(accepted|passed)|review.*artifact',
        'memory_docs_state\s*[:=]\s*(memory_delivery|not-applicable|passed)|memory/docs.*artifact|memory-docs.*artifact',
        'completion_state\s*[:=]\s*complete|completion audit'
    )
    foreach ($pattern in $requiredPatterns) {
        if ($Text -notmatch $pattern) { return $false }
    }
    return $true
}

function Test-HookHasNegatedStationCompletionEvidence {
    param([string]$Text)
    if (-not $Text) { return $false }
    $evidenceToken = '(?:delivery_artifact_id|change[- ]delivery\s+artifact|validation(?:_state|\s+artifact)|review(?:_state|\s+artifact)|memory[-/]docs(?:_state|\s+artifact)|memory\s+docs(?:_state|\s+artifact)|completion\s+audit)'
    $negativeTerm = '(?:missing|lack|lacks|lacking|without|absent|unavailable|not\s+provided|not\s+supplied|unprovided|\u7F3A\u5C11|\u672A\u63D0\u4F9B|\u6C92\u6709|\u7121)'
    $precisePatterns = @(
        ('(?is)\b(?:no)\s+(?:the\s+)?{0}\b' -f $evidenceToken),
        ('(?is)(?:{0})\s+(?:the\s+)?{1}\b' -f $negativeTerm, $evidenceToken),
        ('(?is)\b{0}\b(?:\s|[;:,.]){{0,24}}(?:{1})' -f $evidenceToken, $negativeTerm),
        '(?is)\bartifact\b(?:\s|[;:,.]){{0,16}}(?:missing|unavailable|not\s+provided|not\s+supplied|unprovided)',
        '(?is)(?:missing|unavailable|not\s+provided|not\s+supplied|unprovided)(?:\s|[;:,.]){{0,16}}\bartifact\b',
        '(?is)(?:\u7F3A\u5C11|\u672A\u63D0\u4F9B|\u6C92\u6709|\u7121)(?:\s|[;:,.]){{0,16}}\bartifact\b'
    )
    foreach ($pattern in $precisePatterns) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Test-HookHasConflictingCompletionState {
    param([string]$Text)
    if (-not (Test-HookHasCompletionClaim -Text $Text)) { return $false }
    return (Test-HookHasNonCompleteState -Text $Text)
}

function Test-HookHasCaptainSubstituteCompletionSignal {
    param([string]$Text)
    if (-not $Text) { return $false }
    foreach ($pattern in @(
        '(?is)\bcaptain\s+broad\s+read\b',
        '(?is)\bcaptain\s+substitute\b',
        '(?is)\bcaptain_authored\s*[:=]\s*true\b',
        '(?is)\bdirect_exception\b.{0,100}(?:support|supports|\u652F\u6490|\u8996\u70BA|\u7576\u6210|\u7528|\u4F5C\u70BA|completion\s+evidence|complete|completed|full\s+complete|\u5B8C\u6210\u8B49\u64DA|\u5B8C\u6210\u5BA3\u7A31)',
        '(?is)(?:support|supports|\u652F\u6490|\u8996\u70BA|\u7576\u6210|\u7528|\u4F5C\u70BA|completion\s+evidence|complete|completed|full\s+complete|\u5B8C\u6210\u8B49\u64DA|\u5B8C\u6210\u5BA3\u7A31).{0,100}\bdirect_exception\b'
    )) {
        if ($Text -match $pattern) { return $true }
    }
    return $false
}

function Get-HookStopRisk {
    param([string]$Text)
    if (-not (Test-HookHasCompletionClaim -Text $Text)) { return $null }
    if (Test-HookHasConflictingCompletionState -Text $Text) {
        return [PSCustomObject]@{
            Code = 'TN-HOOK-COMPLETION-CONFLICTING-STATE'
            Missing = 'rewrite mixed final-state claim and non-complete state'
        }
    }
    if (Test-HookHasCaptainSubstituteCompletionSignal -Text $Text) {
        return [PSCustomObject]@{
            Code = 'TN-HOOK-CAPTAIN-SUBSTITUTE-COMPLETION'
            Missing = 'station-owned completion evidence'
        }
    }
    if ($Text -match '(?i)memory[-/]docs|memory_docs|memory docs' -and $Text -notmatch '(?i)memory_docs_state|memory[-/]docs.*artifact|memory delivery') {
        return [PSCustomObject]@{
            Code = 'TN-HOOK-MEMORY-DOCS-CAPTAIN-SUBSTITUTION'
            Missing = 'memory_docs_state, memory/docs delivery artifact'
        }
    }
    if ($Text -match '(?i)external research|external_research|grounding' -and $Text -notmatch 'external_research_artifact_id\s*[:=]\s*[A-Za-z0-9._-]+') {
        return [PSCustomObject]@{
            Code = 'TN-HOOK-EXTERNAL-RESEARCH-MISSING-ARTIFACT'
            Missing = 'external_research_artifact_id'
        }
    }
    if (-not (Test-HookHasStationCompletionEvidence -Text $Text)) {
        return [PSCustomObject]@{
            Code = 'TN-HOOK-COMPLETION-MISSING-STATION-EVIDENCE'
            Missing = 'change delivery, validation, review, memory/docs, final-audit artifacts'
        }
    }
    return $null
}

function Write-StopAllow {
    param([switch]$CompletionEvidence)
    $messageKey = if ($CompletionEvidence) { 'StopCompleteAllowedSystemMessage' } else { 'StopNonCompleteAllowedSystemMessage' }
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key $messageKey)
    })
}

function Write-StopRiskAdvisory {
    param([object]$Risk)
    $message = (Get-HookMessage -Key 'StopRiskAdvisorySystemMessage') -f $Risk.Code, $Risk.Missing
    $message = "$message`nCOMPLETION_EVIDENCE_WARNING=true`nDIRECTOR_FINAL_ACCEPTANCE_REQUIRED=true"
    Write-HookJson -Body ([ordered]@{
        systemMessage = $message
    })
}

function Write-StopReminder {
    param([object]$Payload)
    $rawText = Get-HookActionText -Payload $Payload
    $text = Remove-HookStopClassificationNoise -Text $rawText
    if (Test-HookStopActiveNonClaimEcho -Payload $Payload -RawText $rawText -ClassifiedText $text) {
        Write-StopAllow
        return
    }
    $risk = Get-HookStopRisk -Text $text
    if ($null -ne $risk) {
        Write-StopRiskAdvisory -Risk $risk
        return
    }
    Write-StopAllow -CompletionEvidence:(Test-HookHasCompletionClaim -Text $text)
}

function Test-HookSubagentStopMissingFields {
    param([string]$Text)
    $missing = New-Object System.Collections.Generic.List[string]
    if (-not $Text) {
        $missing.Add('summary')
        $missing.Add('evidence')
        $missing.Add('risk')
        $missing.Add('next steps')
        return $missing
    }
    if ($Text -notmatch '(?i)\b(summary|status)\b|\u6458\u8981|\u72C0\u614B') { $missing.Add('summary') }
    if ($Text -notmatch '(?i)\b(evidence|files?|commands?|source|proof)\b|\u8B49\u64DA|\u6A94\u6848|\u547D\u4EE4|\u4F86\u6E90') { $missing.Add('evidence') }
    if ($Text -notmatch '(?i)\b(risk|blocker|blocking|residual)\b|\u98A8\u96AA|\u963B\u64CB|\u53D7\u963B|\u5269\u9918') { $missing.Add('risk') }
    if ($Text -notmatch '(?i)\b(next\s+steps?|next\s+action|follow[- ]?up|handoff|recommendation|blocking)\b|\u4E0B\u4E00\u6B65|\u5EFA\u8B70|\u4EA4\u63A5|\u5F8C\u7E8C|\u963B\u64CB|\u53D7\u963B') { $missing.Add('next steps') }
    return $missing
}

function Write-SubagentStopReminder {
    param([object]$Payload)
    $text = ConvertTo-HookText -Value (Get-HookPropertyValue -Object $Payload -Names @('last_assistant_message','message','text'))
    $missing = @(Test-HookSubagentStopMissingFields -Text $text)
    if ($missing.Count -gt 0) {
        Write-HookJson -Body ([ordered]@{
            decision = 'block'
            reason = ('Subagent delivery is missing: {0}. Return summary, evidence, risk, and next steps before closing.' -f ($missing -join ', '))
            systemMessage = (Get-HookMessage -Key 'SubagentStopBlockedSystemMessage')
        })
        return
    }
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'SubagentStopAllowedSystemMessage')
    })
}

$rawInput = [Console]::In.ReadToEnd()
if (-not $rawInput -and $env:AI_RULES_HOOK_STDIN) {
    $rawInput = $env:AI_RULES_HOOK_STDIN
}
try {
    $payload = $rawInput | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-PreToolUseReminder -Payload ([PSCustomObject]@{}) -Reason (Get-HookMessage -Key 'BadInputReason')
    exit 0
}

$eventName = [string](Get-HookPropertyValue -Object $payload -Names @('hook_event_name','event','hook_event','codex_hook_event'))
switch ($eventName) {
    'SessionStart' { Write-SessionStartReminder -Payload $payload }
    'UserPromptSubmit' { Write-UserPromptSubmitReminder }
    'SubagentStart' { Write-SubagentStartReminder }
    'PreToolUse' { Write-PreToolUseReminder -Payload $payload }
    'Stop' { Write-StopReminder -Payload $payload }
    'SubagentStop' { Write-SubagentStopReminder -Payload $payload }
    default { Write-PreToolUseReminder -Payload $payload -Reason ((Get-HookMessage -Key 'UnknownEventReasonFormat') -f $eventName) }
}

exit 0
