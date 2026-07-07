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
        SessionStartupContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrlnJjpmormqKHlvI/mj5DphpLjgILlsI3oqbHplovlp4vmiJbmgaLlvqnmmYLvvIzoi6Xnm67liY3lt6XkvZzmtonlj4rmsrvnkIbjgIHkv67lvqnjgIHlu7rmp4vjgIHmuKzoqabjgIHlr6nmn6XjgIHoqJjmhrYv5paH5Lu244CBY29tbWl0IOaIliBoYW5kb2Zm77yM6YCZ5YCLIGhvb2sg5rOo5YWl5Y2z6KGo56S655uu5YmN5rK755CG6KaB5rGC5bey5piO56K66KaB5rGC56uZ6bue5YiG5bel6IiH5b+F6KaB55qE5a2Q5Luj55CGL+maiuWToea0vuW3pe+8m+S4jeimgeino+iugOeCuuaykuacieS9v+eUqOiAheimgeaxguS7o+eQhi/liIblt6XjgILoq4vlhYjmtL7nq5npu57jgIHmmI7norrop5LoibIv56+E5ZyNL+S6pOS7mOS7tu+8m+mcgOimgeaZguWPr+mWi+WtkOS7o+eQhu+8jOS9huiri+WFiOWujOaIkOermem7nuS6pOaOpe+8jOWGjeWBmuW7o+Wfn+iugOOAgeWvq+WFpeOAgempl+itieaIluWujOaIkOWbnuWgseOAgg=='
        SessionOtherSourceContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrmraQgU2Vzc2lvblN0YXJ0IOS+hua6kOS4jeaYryBzdGFydHVwL3Jlc3VtZe+8m+ebruWJjSBob29rcy5qc29uIOaHieWPquWMuemFjSBzdGFydHVwL3Jlc3VtZeOAgg=='
        SessionSystemMessage = '5ZyY6ZqK5qih5byP5o+Q6YaS77yaZ292ZXJuZWQgd29yayDlt7LopoHmsYLnq5npu57liIblt6XoiIflv4XopoHnmoTlrZDku6PnkIYv6ZqK5ZOh5rS+5bel77yb5Y+v6ZaL5a2Q5Luj55CG77yM6KuL5YWI5rS+56uZ6bue77yM5YaN5Z+36KGM56uZ6bue5bel5L2c44CC'
        PreToolContextFormat = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrpgJnmmK/mj5DphpLmqKHlvI/vvIzkuI3mnIPpmLvmk4vlt6XlhbfjgILlsI0gZ292ZXJuZWQgd29ya++8jOmAmeWAiyBob29rIOazqOWFpeetieWQjOebruWJjeayu+eQhuimgeaxguW3suaYjueiuuimgeaxguermem7nuWIhuW3peiIh+W/heimgeeahOWtkOS7o+eQhi/pmorlk6HmtL7lt6XvvJvkuI3opoHop6PoroDngrrmspLmnInkvb/nlKjogIXopoHmsYLku6PnkIYv5YiG5bel44CC5L2g54++5Zyo5Y+v6IO95q2j5rqW5YKZ5Z+36KGM6ZqK5ZOhL+ermem7nuW3peS9nO+8m+iri+WFiOWBnOatoumAmeasoeW3peWFt+WRvOWPq+aIluS4jeimgeebtOaOpee5vOe6jOOAguiri+aUuea0vuermem7nuOAgeeiuuiqjeermem7ni/nr4TlnI3vvIzmiJbmqJnoqJjmnKrpqZforYnjgILkuI3opoHnm7TmjqXmm7/pmorlk6HlrozmiJDlu6Pln5/oroDlj5bjgIHpqZforYnjgIHlr6nmn6XjgIHoqJjmhrYv5paH5Lu25q245bGs5oiW5a+r5YWl44CC5bel5YW35YiG6aGe77yaezB944CC'
        PreToolSystemMessage = '5o+Q6YaS5qih5byP77yM5LiN5pyD6Zi75pOL5bel5YW344CC5bCNIGdvdmVybmVkIHdvcmvvvIzpgJnlgIsgaG9vayDms6jlhaXnrYnlkIznm67liY3msrvnkIbopoHmsYLlt7LmmI7norropoHmsYLnq5npu57liIblt6XoiIflv4XopoHnmoTlrZDku6PnkIYv6ZqK5ZOh5rS+5bel77yb5LiN6KaB6Kej6K6A54K65rKS5pyJ5L2/55So6ICF6KaB5rGC5Luj55CGL+WIhuW3peOAguS9oOePvuWcqOWPr+iDveato+a6luWCmeWft+ihjOmaiuWToS/nq5npu57lt6XkvZzvvJvoq4vlhYjlgZzmraLpgJnmrKHlt6Xlhbflkbzlj6vmiJbkuI3opoHnm7TmjqXnubznuozjgILoq4vmlLnmtL7nq5npu57jgIHnorroqo3nq5npu54v56+E5ZyN77yM5oiW5qiZ6KiY5pyq6amX6K2J44CC5LiN6KaB55u05o6l5pu/6ZqK5ZOh5a6M5oiQ5buj5Z+f6K6A5Y+W44CB6amX6K2J44CB5a+p5p+l44CB6KiY5oa2L+aWh+S7tuatuOWxrOaIluWvq+WFpeOAgg=='
        PreToolDenyRepoScanReason = '5bey6Zi75pOL5YWoIHJlcG8g5o6D5o+P77yM6KuL5YWI5rS+56uZ6bue5oiW5pS555So5ZG95ZCN5qqUL+eqhOevhOWcjeiugOWPluOAgg=='
        BadInputReason = '6Ly45YWl5LiN5piv5pyJ5pWIIEpTT07vvJvmraTmoYjkvovlj6rlgZogYmFkLWlucHV0IHNtb2tl77yM5LuN57at5oyB5o+Q6YaS5qih5byP5Lim5YWB6KixIGhvc3Qg57m857qM44CC'
        UnknownEventReasonFormat = '55uu5YmN5LqL5Lu25pyq5o6b5rex5bGkIGdhdGXvvJp7MH3jgII='
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

function Test-HookExactSafeRepoInventoryCommand {
    param([string]$Command)
    if (-not $Command) { return $false }
    $safeInventoryCommands = @('rg --files','rg.exe --files','git ls-files','git.exe ls-files')
    return ($safeInventoryCommands -ccontains $Command.Trim())
}

function Test-HookDeniedRepoScan {
    param([object]$Payload, [string]$Text)
    if (-not $Text) { return $false }

    $toolName = [string](Get-HookPropertyValue -Object $Payload -Names @('tool_name'))
    $command = Get-HookExecutableCommand -Payload $Payload
    $looksExecutable = ($command -ne '') -or ($toolName -match '(Bash|Shell|PowerShell|pwsh|cmd|exec_command|terminal)')
    if (-not $looksExecutable) { return $false }

    if ((Test-HookAllowedOuterAgent -Payload $Payload) -and (Test-HookExactSafeRepoInventoryCommand -Command $command)) {
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
    default { Write-PreToolUseReminder -Payload $payload -Reason ((Get-HookMessage -Key 'UnknownEventReasonFormat') -f $eventName) }
}

exit 0
