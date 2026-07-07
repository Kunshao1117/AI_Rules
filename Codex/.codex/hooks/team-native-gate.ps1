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
        BadInputReason = '6Ly45YWl5LiN5piv5pyJ5pWIIEpTT07vvJtiYWQtaW5wdXQgc21va2XjgILnpoHmraLmiornhKHmlYggcGF5bG9hZCDnlbbmiJDnq5npu57orYnmk5rvvJvlj6rlhYHoqLEgaG9zdCDnubznuozkuKbkv53nlZkgYWR2aXNvcnkvcmVtaW5kZXLjgII='
        UnknownEventReasonFormat = '55uu5YmN5LqL5Lu25pyq5o6b5rex5bGkIGdhdGXvvJp7MH3jgILnpoHmraLmiormnKrnn6Xkuovku7bovLjlh7rnlbbkvZzlrozmiJDorYnmk5rjgII='
        StopNonCompleteAllowedSystemMessage = '5a6M5oiQ6ZaY6ZaA5o+Q6YaS77ya5Zue6KaG5bey5L2/55SoIGJsb2NrZWQgLyB1bnZlcmlmaWVkIC8gY2xvc2VkLXdpdGgtZGlyZWN0b3ItcmlzayAvIHBhcnRpYWwg562J6Z2e5a6M5oiQ54uA5oWL77yb5YWB6Kix6YCB5Ye677yM5L2G5LiN5Y+v5a6j56ixIGNvbXBsZXRl44CC'
        StopCompleteAllowedSystemMessage = '5a6M5oiQ6ZaY6ZaA5o+Q6YaS77ya5bey5YG15ris5Yiw56uZ6bue5Lqk5LuY6Y+I6IiHIGNvbXBsZXRpb24gYXVkaXTvvJvlhYHoqLHpgIHlh7rlrozmlbTlrozmiJDlrqPnqLHjgII='
        StopBlockedSystemMessage = '5a6M5oiQ6ZaY6ZaA5bey6Zi75pOL77ya56aB5q2i5Zyo57y65bCR56uZ6bue6K2J5pOa5pmC5a6j56ixIGNvbXBsZXRl44CC5YWB6Kix5pS55oiQIHBhcnRpYWwgLyB1bnZlcmlmaWVkIC8gYmxvY2tlZCAvIGNsb3NlZC13aXRoLWRpcmVjdG9yLXJpc2vvvIzmiJboo5zpvYogc3RhdGlvbi1vd25lZCBkZWxpdmVyeSBhcnRpZmFjdHMg5b6M5YaN6YCB5Ye644CC'
        StopBlockedContext = '56aB5q2i5LqL6aCF77ya6ZqK6ZW35LiN5b6X55u05o6l55Si55SfIGNvbXBsZXRpb24gZXZpZGVuY2XvvIzkuI3og73nlKggY2FwdGFpbiBicm9hZCByZWFk44CBZGlyZWN0X2V4Y2VwdGlvbiDmiJbnvLrlsJEgbWVtb3J5L2RvY3Mg55qEIGFydGlmYWN0IGNoYWluIOWuo+eosSBjb21wbGV0ZeOAguWFgeioseS6i+mghe+8muWbnuWgsSBwYXJ0aWFs44CBdW52ZXJpZmllZOOAgWJsb2NrZWTjgIFjbG9zZWQtd2l0aC1kaXJlY3Rvci1yaXNr77yM5oiW5Lqk55SxIGZvcm1hbCBjb21wbGV0aW9uIHN0YXRpb24g5qqi5p+l44CC6ZmN57Sa5b6M5p6c77ya57y65bCRIGV4dGVybmFsX3Jlc2VhcmNoX2FydGlmYWN0X2lkIOeahCBleHRlcm5hbCByZXNlYXJjaCDlj6rog70gdW52ZXJpZmllZC9wYXJ0aWFsL2Jsb2NrZWTjgIJSZWFzb24gY29kZTogezB944CCTWlzc2luZyBzdHJ1Y3R1cmVkIGZpZWxkczogezF944CCQWxsb3dlZCBuZXh0IHN0ZXBzOiB1c2Ugbm9uLWNvbXBsZXRlIHN0YXRlIG9yIHByb3ZpZGUgc3RhdGlvbi1vd25lZCBhcnRpZmFjdHMuIEZvcmJpZGRlbiBuZXh0IHN0ZXBzOiBkbyBub3QgY2xhaW0gY29tcGxldGUgZnJvbSBjYXB0YWluIHN1YnN0aXR1dGUgZXZpZGVuY2Uu'
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

function Get-HookActionText {
    param([object]$Payload)
    $parts = New-Object System.Collections.Generic.List[string]
    foreach ($name in @('tool_name','command','action','target','path','file_path','patch','prompt','message','text','raw_text')) {
        $value = Get-HookPropertyValue -Object $Payload -Names @($name)
        if ($null -ne $value -and [string]$value -ne '') { $parts.Add((ConvertTo-HookText -Value $value)) }
    }

    $toolInput = Get-HookPropertyValue -Object $Payload -Names @('tool_input','input','payload')
    if ($null -ne $toolInput -and $toolInput -ne $Payload) {
        foreach ($name in @('command','action','target','path','file_path','patch','prompt','message','text')) {
            $value = Get-HookPropertyValue -Object $toolInput -Names @($name)
            if ($null -ne $value -and [string]$value -ne '') { $parts.Add((ConvertTo-HookText -Value $value)) }
        }
    }

    return (($parts -join "`n").Trim())
}

function Get-HookExecutableCommand {
    param([object]$Payload)
    $command = Get-HookPropertyValue -Object $Payload -Names @('command')
    $toolInput = Get-HookPropertyValue -Object $Payload -Names @('tool_input','input','payload')
    if ($null -ne $toolInput -and $toolInput -ne $Payload) {
        $inputCommand = Get-HookPropertyValue -Object $toolInput -Names @('command','script')
        if ($null -ne $inputCommand -and [string]$inputCommand -ne '') { $command = $inputCommand }
    }
    return (ConvertTo-HookText -Value $command).Trim()
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
    Write-HookJson -Body ([ordered]@{
        systemMessage = (Get-HookMessage -Key 'SessionSystemMessage')
        hookSpecificOutput = [ordered]@{
            hookEventName = 'SessionStart'
            additionalContext = $context
        }
    })
}

function Write-PreToolUseDeny {
    $reason = Get-HookMessage -Key 'PreToolDenyRepoScanReason'
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
    return ($Text -match '(?i)\b(blocked|unverified|closed-with-director-risk|partial)\b|\u672A\u9A57\u8B49|\u53D7\u963B|\u963B\u585E|\u90E8\u5206\u5B8C\u6210|\u98A8\u96AA\u95DC\u9589')
}

function Remove-HookNegatedCompletionReference {
    param([string]$Text)
    if (-not $Text) { return '' }
    $clean = $Text
    foreach ($pattern in @(
        '(?is)(?:\u4E0D(?:\u53EF|\u80FD|\u6703)?|\u4E0D\u8981|\u672A|\u4E26\u672A|\u4E0D\u6703)\s*(?:\u5BA3\u7A31|\u8072\u7A31|\u8868\u793A|\u8996\u70BA)?\s*(?:full\s+)?complete',
        '(?is)(?:must\s+not|do\s+not|cannot|can\s+not|not)\s+(?:claim\s+)?(?:full\s+)?complete',
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
    return ($searchText -match '(?i)\bcompletion_state\s*[:=]\s*complete\b|\b(complete|completed|done|finished|all set)\b|\u5DF2\u5B8C\u6210|\u5B8C\u6210\u4E86|\u5168\u90E8\u5B8C\u6210|\u53EF\u4EE5\u6536\u5C3E|\u53EF\u6536\u5C3E|(?:\u4F46|\u73FE\u5728|\u76EE\u524D|\u4EFB\u52D9|\u5DE5\u4F5C|\u4FEE\u6539).{0,8}\u5B8C\u6210')
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
            Missing = 'rewrite mixed complete claim and non-complete state'
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
            Missing = 'change delivery, validation, review, memory/docs, completion audit artifacts'
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

function Write-StopBlock {
    param([object]$Risk)
    $context = (Get-HookMessage -Key 'StopBlockedContext') -f $Risk.Code, $Risk.Missing
    Write-HookJson -Body ([ordered]@{
        decision = 'block'
        reason = $context
        systemMessage = (Get-HookMessage -Key 'StopBlockedSystemMessage')
    })
}

function Write-StopReminder {
    param([object]$Payload)
    $text = Get-HookActionText -Payload $Payload
    $risk = Get-HookStopRisk -Text $text
    if ($null -ne $risk) {
        Write-StopBlock -Risk $risk
        return
    }
    Write-StopAllow -CompletionEvidence:(Test-HookHasCompletionClaim -Text $text)
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
    'PreToolUse' { Write-PreToolUseReminder -Payload $payload }
    'Stop' { Write-StopReminder -Payload $payload }
    default { Write-PreToolUseReminder -Payload $payload -Reason ((Get-HookMessage -Key 'UnknownEventReasonFormat') -f $eventName) }
}

exit 0
