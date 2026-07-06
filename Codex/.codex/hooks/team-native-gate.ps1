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
        SessionStartupContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrlnJjpmormqKHlvI/mj5DphpLjgILlsI3oqbHplovlp4vmiJbmgaLlvqnmmYLvvIzoi6Xnm67liY3lt6XkvZzmmK/msrvnkIbjgIHkv67lvqnjgIHlu7rmp4vjgIHmuKzoqabjgIHlr6nmn6XjgIHoqJjmhrYv5paH5Lu244CBY29tbWl0IOaIliBoYW5kb2Zm77yM6KuL5YWI5rS+56uZ6bue44CB5piO56K66KeS6ImyL+evhOWcjS/kuqTku5jku7bvvJvpnIDopoHmmYLlj6/plovlrZDku6PnkIbvvIzkvYboq4vlhYjlrozmiJDnq5npu57kuqTmjqXvvIzlho3lgZrlu6PoroDjgIHlr6vlhaXjgIHpqZforYnmiJblrozmiJDlm57loLHjgII='
        SessionOtherSourceContext = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrmraQgU2Vzc2lvblN0YXJ0IOS+hua6kOS4jeaYryBzdGFydHVwL3Jlc3VtZe+8m+ebruWJjSBob29rcy5qc29uIOaHieWPquWMuemFjSBzdGFydHVwL3Jlc3VtZeOAgg=='
        SessionSystemMessage = '5ZyY6ZqK5qih5byP5o+Q6YaS77ya5Y+v6ZaL5a2Q5Luj55CG77yb6KuL5YWI5rS+56uZ6bue77yM5YaN5Z+36KGM56uZ6bue5bel5L2c44CC'
        PreToolContextFormat = 'YWR2aXNvcnkvcmVtaW5kZXLvvJrpgJnmmK/mj5DphpLmqKHlvI/vvIzkuI3mnIPpmLvmk4vlt6XlhbfjgILkvaDnj77lnKjlj6/og73mraPmupblgpnln7fooYzpmorlk6Ev56uZ6bue5bel5L2c77yb6KuL5YWI5YGc5q2i6YCZ5qyh5bel5YW35ZG85Y+r5oiW5LiN6KaB55u05o6l57m857qM44CC6KuL5pS55rS+56uZ6bue44CB56K66KqN56uZ6bueL+evhOWcje+8jOaIluaomeiomOacqumpl+itieOAguS4jeimgeebtOaOpeabv+maiuWToeWujOaIkOW7o+Wfn+iugOWPluOAgempl+itieOAgeWvqeafpeOAgeiomOaGti/mlofku7bmrbjlsazmiJblr6vlhaXjgILlt6XlhbfliIbpoZ7vvJp7MH3jgII='
        PreToolSystemMessage = '5o+Q6YaS5qih5byP77yM5LiN5pyD6Zi75pOL5bel5YW344CC5L2g54++5Zyo5Y+v6IO95q2j5rqW5YKZ5Z+36KGM6ZqK5ZOhL+ermem7nuW3peS9nO+8m+iri+WFiOWBnOatoumAmeasoeW3peWFt+WRvOWPq+aIluS4jeimgeebtOaOpee5vOe6jOOAguiri+aUuea0vuermem7nuOAgeeiuuiqjeermem7ni/nr4TlnI3vvIzmiJbmqJnoqJjmnKrpqZforYnjgILkuI3opoHnm7TmjqXmm7/pmorlk6HlrozmiJDlu6Pln5/oroDlj5bjgIHpqZforYnjgIHlr6nmn6XjgIHoqJjmhrYv5paH5Lu25q245bGs5oiW5a+r5YWl44CC'
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
