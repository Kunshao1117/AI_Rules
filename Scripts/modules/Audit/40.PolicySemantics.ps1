# Internal partial for Audit.psm1. Loaded by the facade only.
# Shared policy semantics and review governance

function Get-AuditSharedPolicyBlock {
    param(
        [string]$PolicyPath,
        [string]$Platform
    )

    if (-not (Test-Path -LiteralPath $PolicyPath)) { return '' }

    $content = Get-Content -LiteralPath $PolicyPath -Raw -Encoding UTF8
    $platformKey = $Platform.ToUpperInvariant()
    $pattern = "(?ms)<!--\s*SUBAGENT_POLICY:$platformKey`_START\s*-->\s*(.*?)\s*<!--\s*SUBAGENT_POLICY:$platformKey`_END\s*-->"
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ''
}

function Get-AuditGeneratedSubagentPolicyBlock {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return '' }

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    $pattern = "(?ms)$([regex]::Escape($startMarker))\s*(.*?)\s*$([regex]::Escape($endMarker))"
    $match = [regex]::Match($content, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ''
}

function Measure-SharedSubagentPolicyDrift {
    <#
    .SYNOPSIS
        檢查 Shared/policies/subagent-invocation.md 與三平台核心規則 marker block 是否一致。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄。
    .PARAMETER TargetRoot
        目前專案根目錄；若已安裝平台規則，列為 Yellow drift 警告。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList
    $policyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'

    function Add-PolicyFinding {
        param(
            [string]$Severity,
            [string]$Platform,
            [string]$Scope,
            [string]$File,
            [string]$Reason
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            Platform = $Platform
            Scope    = $Scope
            File     = $File
            Reason   = $Reason
        })
    }

    if (-not (Test-Path -LiteralPath $policyPath)) {
        Add-PolicyFinding -Severity 'Red' -Platform 'Shared' -Scope 'source' -File 'Shared/policies/subagent-invocation.md' -Reason 'Shared 子代理政策來源不存在'
    }

    $sourceTargets = @(
        [PSCustomObject]@{ Platform = 'Codex'; Path = Join-Path $RepoRoot 'Codex\.codex\AGENTS.md' },
        [PSCustomObject]@{ Platform = 'Claude'; Path = Join-Path $RepoRoot 'Claude\.claude\rules\core-identity.md' },
        [PSCustomObject]@{ Platform = 'Antigravity'; Path = Join-Path $RepoRoot 'Antigravity\.agents\rules\00_core_identity.md' }
    )

    $targetTargets = @(
        [PSCustomObject]@{ Platform = 'Codex'; Path = Join-Path $TargetRoot '.codex\AGENTS.md' },
        [PSCustomObject]@{ Platform = 'Claude'; Path = Join-Path $TargetRoot '.claude\rules\core-identity.md' },
        [PSCustomObject]@{ Platform = 'Antigravity'; Path = Join-Path $TargetRoot '.agents\rules\00_core_identity.md' }
    )

    foreach ($target in $sourceTargets) {
        $expected = Get-AuditSharedPolicyBlock -PolicyPath $policyPath -Platform $target.Platform
        $rel = if (Test-Path -LiteralPath $target.Path) { Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path } else { $target.Path }
        if (-not $expected) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason 'Shared policy 缺少此平台轉譯區塊'
            continue
        }
        if (-not (Test-Path -LiteralPath $target.Path)) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則來源檔不存在'
            continue
        }
        $actual = Get-AuditGeneratedSubagentPolicyBlock -Path $target.Path
        if (-not $actual) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則缺少 shared subagent policy marker block'
        } elseif ($actual -ne $expected) {
            Add-PolicyFinding -Severity 'Red' -Platform $target.Platform -Scope 'source' -File $rel -Reason '平台核心規則 marker block 與 Shared policy 不一致'
        }
    }

    foreach ($target in $targetTargets) {
        if (-not (Test-Path -LiteralPath $target.Path)) { continue }
        $expected = Get-AuditSharedPolicyBlock -PolicyPath $policyPath -Platform $target.Platform
        if (-not $expected) { continue }
        $actual = Get-AuditGeneratedSubagentPolicyBlock -Path $target.Path
        $display = if ($target.Path.StartsWith($RepoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path
        } else {
            "target:$($target.Path.Substring($TargetRoot.Length).TrimStart('\', '/'))"
        }
        if (-not $actual) {
            Add-PolicyFinding -Severity 'Yellow' -Platform $target.Platform -Scope 'target' -File $display -Reason '目前專案核心規則缺少 shared subagent policy marker block'
        } elseif ($actual -ne $expected) {
            Add-PolicyFinding -Severity 'Yellow' -Platform $target.Platform -Scope 'target' -File $display -Reason '目前專案核心規則 marker block 與 Shared policy 不一致'
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 共用子代理政策漂移（Shared Subagent Policy Drift）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, Platform, Scope, File) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}/{2} {3} — {4}" -f $finding.Severity, $finding.Platform, $finding.Scope, $finding.File, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-SubagentVocabularyDrift {
    <#
    .SYNOPSIS
        檢查三平台子代理語彙是否混用：Shared 技能不得硬寫平台專用工具名，Codex workflow 不得使用 Claude 舊式 Agent(subagent_type) 語法。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄。
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-SubagentVocabularyFinding {
        param(
            [string]$Severity,
            [string]$Scope,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            Scope    = $Scope
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    $sharedForbiddenPatterns = @(
        'Agent\s*\(',
        '\bsubagent_type\b',
        '\bbrowser_subagent\b',
        '\bbrowser_agent\b',
        '\bspawn_agent\b',
        '@agent\b',
        '\bnative subagents?\b',
        '\bGemini CLI subagents?\b',
        '\bbrowser-capable agents?\b'
    )
    $sharedScanFiles = @()
    $sharedSkillRoot = Join-Path $RepoRoot 'Shared\skills'
    if (Test-Path -LiteralPath $sharedSkillRoot) {
        $sharedScanFiles += @(Get-ChildItem -LiteralPath $sharedSkillRoot -Recurse -File -Include '*.md')
    }
    $sharedPolicyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'
    if (Test-Path -LiteralPath $sharedPolicyPath) {
        $sharedScanFiles += @(Get-Item -LiteralPath $sharedPolicyPath)
    }

    foreach ($file in $sharedScanFiles) {
        $relative = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $file.FullName
        $lines = Get-Content -LiteralPath $file.FullName -Encoding UTF8
        $insidePlatformTranslation = $false
        $adapterSectionLevel = 0
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($relative -eq 'Shared\policies\subagent-invocation.md' -and $lines[$i] -match '^##\s+(Platform Translation Blocks|平台轉譯區塊)') {
                $insidePlatformTranslation = $true
            }

            if ($lines[$i] -match '^(#+)\s+') {
                $headingLevel = $matches[1].Length
                if ($adapterSectionLevel -gt 0 -and $headingLevel -le $adapterSectionLevel) {
                    $adapterSectionLevel = 0
                }
                if ($lines[$i] -match '(Platform Adapter|Adapter Notes|平台轉譯)') {
                    $adapterSectionLevel = $headingLevel
                }
            }

            if ($insidePlatformTranslation -or $adapterSectionLevel -gt 0) { continue }

            foreach ($pattern in $sharedForbiddenPatterns) {
                if ($lines[$i] -match $pattern) {
                    Add-SubagentVocabularyFinding -Severity 'Red' `
                        -Scope 'Shared' `
                        -File $relative `
                        -Line ($i + 1) `
                        -Reason 'Shared 共用層不得硬寫未標註平台的子代理工具名，請改成 evidence branch / platform adapter 語彙' `
                        -Text $lines[$i].Trim()
                    break
                }
            }
        }
    }

    $codexRoots = @(
        (Join-Path -Path $RepoRoot -ChildPath 'Codex\.agents\workflow-skills')
        (Join-Path -Path $RepoRoot -ChildPath '.agents\skills')
    )
    foreach ($root in $codexRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -File -Include '*.md' | ForEach-Object {
            $lines = Get-Content -LiteralPath $_.FullName -Encoding UTF8
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match 'Agent\(subagent_type') {
                    Add-SubagentVocabularyFinding -Severity 'Red' `
                        -Scope 'Codex' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $_.FullName) `
                        -Line ($i + 1) `
                        -Reason 'Codex workflow 不得使用 Claude 舊式 Agent(subagent_type) 語法' `
                        -Text $lines[$i].Trim()
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 子代理語彙漂移（Subagent Vocabulary Drift）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, Scope, File, Line) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1} {2}:{3} — {4}" -f $finding.Severity, $finding.Scope, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-GovernanceSemantics {
    <#
    .SYNOPSIS
        檢查治理語義：分相授權、GO blanket 授權、舊路徑、自動安裝、automation-safe mutation、MCP HITL 邊界。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-GovernanceFinding {
        param(
            [string]$Severity,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    $globalPatterns = @(
        [PSCustomObject]@{ Pattern = ('WITHOUT' + ' halting'); Reason = 'global bootstrap 不可未授權自動下載執行' },
        [PSCustomObject]@{ Pattern = '\.Codex/(agents|commands)'; Reason = 'Codex 舊路徑殘留' },
        [PSCustomObject]@{ Pattern = ('\.claude/agents' + '/skills'); Reason = 'Claude 舊技能路徑殘留' },
        [PSCustomObject]@{ Pattern = ('雙' + ' AI'); Reason = '舊雙平台概念殘留，需改為三平台或多平台代理' },
        [PSCustomObject]@{ Pattern = 'v1\.1\.0'; Reason = '舊版本描述殘留' },
        [PSCustomObject]@{ Pattern = 'git\s+add\s+\.|git\s+add\s+-A'; Reason = 'commit workflow 不可使用 blanket staging' }
    )

    foreach ($file in (Get-GovernanceScanFiles -RepoRoot $RepoRoot)) {
        $lines = Get-Content -LiteralPath $file -Encoding UTF8
        for ($i = 0; $i -lt $lines.Count; $i++) {
            foreach ($pattern in $globalPatterns) {
                if ($lines[$i] -cmatch $pattern.Pattern) {
                    Add-GovernanceFinding -Severity 'Red' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $file) `
                        -Line ($i + 1) `
                        -Reason $pattern.Reason `
                        -Text $lines[$i].Trim()
                }
            }
        }
    }

    $authorizationForbiddenPatterns = @(
        [PSCustomObject]@{
            Pattern = '(?i)(platform[-_ ]?mode|platform_mode|platform route|平台模式|平台路由).{0,100}(\b(equals?|is|counts?\s+as)\b|等於|代表|視為).{0,100}(authorization|write authorization|授權|寫入授權)'
            Reason = '不得正向宣稱平台模式等於授權'
        },
        [PSCustomObject]@{
            Pattern = '(?i)(workflow|workflow_route|workflow command|工作流|流程路由|工作流指令|\$[0-9]{2}|/[0-9]{2}).{0,100}(\b(equals?|is|counts?\s+as)\b|等於|代表|視為).{0,100}(authorization|write authorization|授權|寫入授權)'
            Reason = '不得正向宣稱工作流等於授權'
        },
        [PSCustomObject]@{
            Pattern = '(?i)(button|buttons|click|confirmation|confirm|consent|按鈕|點擊|確認|同意).{0,100}(\b(equals?|is|counts?\s+as)\b|等於|代表|視為).{0,100}(unscoped|any scope|all files|blanket|without scope|無範圍|不限範圍|所有檔案|任意寫入|全域寫入|無清單寫入).{0,80}(write|mutation|寫入|變更)?'
            Reason = '不得正向宣稱按鈕同意等於無範圍寫入'
        },
        [PSCustomObject]@{
            Pattern = '(?i)(single|same|one|blanket|unscoped|單一|同一個|一次|全域|無範圍).{0,80}\bGO\b.{0,180}(changelog|CHANGELOG\.md|source write|memory|git\s+commit|commit|git\s+push|push|release|deploy|install|變更紀錄|來源寫入|記憶|提交|推送|發布|部署|安裝).{0,180}(authori[sz]e|permission|gate|covers?|授權|涵蓋|允許)'
            Reason = '單一 GO 不得 blanket 授權多個保護階段'
        },
        [PSCustomObject]@{
            Pattern = '(?i)(workflow route|workflow_route|workflow command|工作流路由|工作流指令).{0,120}(authori[sz]es?|permission|covers?|allows?|授權|允許|涵蓋).{0,160}(changelog|source write|memory mutation|git commit|git push|release|deploy|install|保護操作|保護階段)'
            Reason = 'workflow route 不得作為保護階段授權'
        }
    )

    foreach ($file in (Get-GovernanceScanFiles -RepoRoot $RepoRoot)) {
        $lines = Get-Content -LiteralPath $file -Encoding UTF8
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if (Test-AuditLineIsNegative -Line $line) { continue }
            foreach ($pattern in $authorizationForbiddenPatterns) {
                if ($line -match $pattern.Pattern) {
                    Add-GovernanceFinding -Severity 'Red' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $file) `
                        -Line ($i + 1) `
                        -Reason $pattern.Reason `
                        -Text $line.Trim()
                }
            }
        }
    }

    $mutationPattern = '(?i)(\bwrite_to_file\b|\breplace_file_content\b|\bmemory_commit\b|\bgit\s+add\b|\bgit\s+commit\b|\bgit\s+push\b|\bdeploy\b|\binstall\b|\bdelete\b|\bremove-item\b|\bnew-item\b|\bset-content\b|\badd-content\b|\bout-file\b|\bcreate_[a-z0-9_]+\b|\bupdate_[a-z0-9_]+\b|\bpush_files\b|\bapply_migration\b|\bmerge_branch\b|\breset_branch\b|\bdelete_branch\b|\bresolve\b)'
    $protectedPhaseAuthorizationSignals = @(
        [PSCustomObject]@{
            Label = 'scope-bound intent signal'
            Pattern = '(?is)(scope[- ]bound|scoped|scope-bound|範圍綁定|有範圍|綁定範圍).{0,240}(intent signal|Director intent|GO|authorization evidence|意圖訊號|總監意圖|授權證據)|(intent signal|Director intent|GO|authorization evidence|意圖訊號|總監意圖|授權證據).{0,240}(scope[- ]bound|scoped|scope-bound|範圍綁定|有範圍|綁定範圍)'
        },
        [PSCustomObject]@{
            Label = 'authorization resolution'
            Pattern = '(?i)authorization resolution|authorization_resolution|authorization_resolution_state|授權解析'
        },
        [PSCustomObject]@{
            Label = 'protected gate'
            Pattern = '(?i)protected gate|protected authorization|protected-state gate|protected phase gate|保護.{0,40}(gate|閘門|授權)|對應.{0,80}(gate|閘門)'
        },
        [PSCustomObject]@{
            Label = 'separate protected phase'
            Pattern = '(?is)(each|own|respective|per[- ]phase|phase[- ]specific|separate|dedicated|individual|各自|分相|逐相|每個|每一個|單獨|分別|獨立).{0,220}(phase|protected phase|gate|authorization|階段|保護階段|閘門|授權)|(phase|protected phase|階段|保護階段).{0,220}(each|own|respective|separate|dedicated|individual|各自|分相|逐相|單獨|分別|獨立)'
        }
    )
    $protectedPhaseChecks = @(
        [PSCustomObject]@{
            Label = 'changelog/source write'
            OperationPattern = '(?i)(CHANGELOG\.md|changelog write|source write|write_to_file|replace_file_content|set-content|add-content|out-file)'
            PhasePattern = '(?i)(CHANGELOG\.md|changelog write|source write|source[- ]write|source mutation|filesystem write|變更紀錄|來源寫入|檔案寫入)'
        },
        [PSCustomObject]@{
            Label = 'memory mutation'
            OperationPattern = '(?i)(\bmemory_commit\b|memory mutation phase|memory write phase|memory mutation station|memory write station|記憶(提交|寫入|突變)(階段|站點|station)|\.agents[\\/]memory.{0,80}(write|mutation|commit|寫入|提交|突變))'
            PhasePattern = '(?i)(memory mutation|memory write|memory_commit|memory phase|記憶(提交|寫入|變更|突變)|記憶階段)'
        },
        [PSCustomObject]@{
            Label = 'git commit'
            OperationPattern = '(?i)\bgit\s+commit\b'
            PhasePattern = '(?i)(git commit|commit phase|提交階段|提交授權)'
        },
        [PSCustomObject]@{
            Label = 'push'
            OperationPattern = '(?i)(\bgit\s+push\b|\bpush_files\b)'
            PhasePattern = '(?i)(git push|push phase|push_files|推送階段|推送授權)'
        },
        [PSCustomObject]@{
            Label = 'release/deploy/install'
            OperationPattern = '(?i)(\bgh\s+release\b|\bgit\s+tag\b|\b(vercel|wrangler|netlify)\s+deploy\b|\b(npm|pnpm|yarn|bun)\s+install\b|release/deploy/install phase|release phase|deploy phase|install phase|發布階段|部署階段|安裝階段)'
            PhasePattern = '(?i)(release|deploy|deployment|install|release/deploy/install|發布|部署|安裝)'
        }
    )

    function Test-GovernancePositiveLineMatch {
        param(
            [string[]]$Lines,
            [string]$Pattern
        )

        foreach ($line in @($Lines)) {
            if (($line -match $Pattern) -and (-not (Test-AuditLineIsNegative -Line $line))) {
                return $true
            }
        }

        return $false
    }

    function Get-MissingProtectedPhaseSignals {
        param(
            [string]$Content,
            [string]$PhasePattern
        )

        $missing = New-Object System.Collections.Generic.List[string]
        if ($Content -notmatch $PhasePattern) {
            $missing.Add('phase label')
        }

        foreach ($signal in $protectedPhaseAuthorizationSignals) {
            if ($Content -notmatch $signal.Pattern) {
                $missing.Add($signal.Label)
            }
        }

        return @($missing.ToArray())
    }

    foreach ($target in (Get-WorkflowAuditTargets -RepoRoot $RepoRoot)) {
        $content = Get-Content -LiteralPath $target.Path -Raw -Encoding UTF8
        $lines = Get-Content -LiteralPath $target.Path -Encoding UTF8
        $fm = Get-FrontmatterBlock -Path $target.Path
        $lifecycle = Get-AuditMetadataValue -Frontmatter $fm -Field 'lifecycle_phase'
        $toolScope = Get-AuditMetadataValue -Frontmatter $fm -Field 'tool_scope'
        $humanGate = Get-AuditMetadataValue -Frontmatter $fm -Field 'human_gate'
        $automationSafe = $fm -match '(?m)^\s+automation_safe:\s*true\s*$'
        $isExperiment = $lifecycle -eq 'experiment'
        $hasWriteScope = $toolScope -match 'write|git:write'
        $logsOnlyScope = $toolScope -match 'filesystem:write:logs'
        $noHumanGate = $humanGate -match '^(none|false|no)$'

        if ($isExperiment) {
            if ($automationSafe) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path) `
                    -Line 1 `
                    -Reason 'experiment workflow 可保留沙盒可寫例外，但不可標為 automation_safe' `
                    -Text $target.Name
            }
            continue
        }

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -notmatch $mutationPattern) { continue }
            if (Test-AuditLineIsNegative -Line $line) { continue }

            $rel = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path
            if ($automationSafe) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'automation-safe workflow 不可包含可執行變異指令' `
                    -Text $line.Trim()
                continue
            }

            if ($logsOnlyScope -and ($line -match '(?i)(write_to_file|replace_file_content|set-content|add-content|out-file|write)') -and ($line -notmatch '\.agents/logs')) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'filesystem:write:logs 只能寫入 .agents/logs/ 中繼報告' `
                    -Text $line.Trim()
                continue
            }

            if ((-not $hasWriteScope) -and $noHumanGate) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File $rel `
                    -Line ($i + 1) `
                    -Reason 'metadata 宣告 read-scope 且無 human gate，但正文包含變異操作' `
                    -Text $line.Trim()
            }
        }

        foreach ($phaseCheck in $protectedPhaseChecks) {
            if (-not (Test-GovernancePositiveLineMatch -Lines $lines -Pattern $phaseCheck.OperationPattern)) { continue }

            $missingPhaseSignals = Get-MissingProtectedPhaseSignals -Content $content -PhasePattern $phaseCheck.PhasePattern
            if (@($missingPhaseSignals).Count -gt 0) {
                Add-GovernanceFinding -Severity 'Red' `
                    -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $target.Path) `
                    -Line 1 `
                    -Reason ("protected phase `{0}` 缺少分相授權語意" -f $phaseCheck.Label) `
                    -Text ("缺少：{0}" -f ($missingPhaseSignals -join ', '))
            }
        }
    }

    $sharedSkillsRoot = Join-Path $RepoRoot 'Shared\skills'
    if (Test-Path -LiteralPath $sharedSkillsRoot) {
        Get-ChildItem -LiteralPath $sharedSkillsRoot -Filter 'SKILL.md' -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -match '[\\/]Shared[\\/]skills[\\/][^\\/]+[\\/]SKILL\.md$' } |
            ForEach-Object {
                $content = Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
                $isMcpSkill = $content -match '(?m)^\s*mcp_servers:\s*|mcp:[a-zA-Z0-9_-]+'
                $hasMutationTool = $content -match '(?i)`[^`\r\n]*(create|update|write|delete|deploy|push|apply|reset|merge|memory_commit|resolve_issue|resolve-issue)[a-z0-9_-]*[^`\r\n]*`'
                $hasHitl = ($content -match '## HITL Boundary') -and ($content -match '\[MCP HITL GATE\]')
                if ($isMcpSkill -and $hasMutationTool -and (-not $hasHitl)) {
                    Add-GovernanceFinding -Severity 'Yellow' `
                        -File (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $_.FullName) `
                        -Line 1 `
                        -Reason 'MCP 高風險操作技能缺少標準 HITL/GO 邊界' `
                        -Text $_.Directory.Name
                }
            }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 治理語義（Governance Semantics）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Line) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
        if ($finding.Text) {
            Write-Host ("      {0}" -f $finding.Text) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}

function Measure-ReviewGovernanceCoverage {
    <#
    .SYNOPSIS
        檢查工程審查治理是否覆蓋共用技能、矩陣、政策與三平台工作流入口。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    .PARAMETER TargetRoot
        目前專案根目錄，用於檢查部署後副本是否同步。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-ReviewGovernanceFinding {
        param(
            [string]$Severity,
            [string]$File,
            [int]$Line,
            [string]$Reason,
            [string]$Text
        )

        $null = $results.Add([PSCustomObject]@{
            Severity = $Severity
            File     = $File
            Line     = $Line
            Reason   = $Reason
            Text     = $Text
        })
    }

    function Get-ReviewGovernanceContent {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path)) { return $null }
        return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8)
    }

    function Get-ReviewGovernanceReferenceTokens {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return @() }

        $tokens = New-Object System.Collections.Generic.List[string]
        foreach ($match in [regex]::Matches($Content, '`([^`]+\.md)`')) {
            $token = $match.Groups[1].Value.Trim()
            if ($token) { $tokens.Add($token) }
        }

        return @($tokens.ToArray() | Select-Object -Unique)
    }

    function Resolve-ReviewGovernanceCandidatePath {
        param([string]$Path)

        if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
        try {
            return [System.IO.Path]::GetFullPath($Path)
        } catch {
            return $null
        }
    }

    function Test-ReviewGovernanceCandidateUnderAllowedRoot {
        param([string]$Path)

        $candidateFull = Resolve-ReviewGovernanceCandidatePath -Path $Path
        if (-not $candidateFull) { return $false }
        $candidateFull = $candidateFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

        foreach ($root in @($RepoRoot, $TargetRoot)) {
            $rootFull = Resolve-ReviewGovernanceCandidatePath -Path $root
            if (-not $rootFull) { continue }
            $rootFull = $rootFull.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
            if ($candidateFull.Equals($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }

            $rootWithSeparator = $rootFull + [System.IO.Path]::DirectorySeparatorChar
            if ($candidateFull.StartsWith($rootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) { return $true }
        }

        return $false
    }

    function Add-ReviewGovernanceReferenceCandidate {
        param(
            [System.Collections.Generic.List[string]]$Candidates,
            [string]$Path
        )

        $resolvedPath = Resolve-ReviewGovernanceCandidatePath -Path $Path
        if ($resolvedPath -and (Test-ReviewGovernanceCandidateUnderAllowedRoot -Path $resolvedPath)) {
            $Candidates.Add($resolvedPath)
        }
    }

    function Get-ReviewGovernanceReferenceCandidatePaths {
        param([string]$Reference)
        if ([string]::IsNullOrWhiteSpace($Reference)) { return @() }

        $normalized = $Reference.Trim()
        $normalized = $normalized.Trim([char]0x60).Trim([char]34).Trim([char]39) -replace '/', '\'
        if (-not $normalized) { return @() }

        $candidates = New-Object System.Collections.Generic.List[string]
        if ([System.IO.Path]::IsPathRooted($normalized)) {
            Add-ReviewGovernanceReferenceCandidate -Candidates $candidates -Path $normalized
        } else {
            Add-ReviewGovernanceReferenceCandidate -Candidates $candidates -Path (Join-Path $RepoRoot $normalized)
            Add-ReviewGovernanceReferenceCandidate -Candidates $candidates -Path (Join-Path $TargetRoot $normalized)

            if ($normalized -match '^Shared\\(.+)$') {
                Add-ReviewGovernanceReferenceCandidate -Candidates $candidates -Path (Join-Path $TargetRoot (Join-Path '.agents\shared' $Matches[1]))
            }
            if ($normalized -match '^\.agents\\shared\\(.+)$') {
                Add-ReviewGovernanceReferenceCandidate -Candidates $candidates -Path (Join-Path $RepoRoot (Join-Path 'Shared' $Matches[1]))
            }
        }

        return @($candidates.ToArray() | Select-Object -Unique)
    }

    function Test-ReviewGovernanceReferenceContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasLifecycle = $Content -match 'Review Lifecycle Governance Matrix|Review Lifecycle States|review lifecycle|審查生命週期'
        $hasReviewState = $Content -match 'review state|Review state|Review-state|fixed-pending-validation|collecting-evidence|findings-open'
        $hasReadiness = $Content -match '(?is)release/completion readiness|completion readiness|readiness evidence|completion gate|review.{0,80}completion|completion.{0,80}review'
        $hasRiskAcceptance = (
            $Content -match 'accepted-risk' -and
            $Content -match '(?is)bounded risk|Director-visible limitation|closed-with-director-risk|risk'
        )

        return ($hasLifecycle -and $hasReviewState -and $hasReadiness -and $hasRiskAcceptance)
    }

    function Test-ReviewGovernanceBodyOrReferenceContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }
        if (Test-ReviewGovernanceReferenceContent -Content $Content) { return $true }

        $visited = @{}
        $frontier = @($Content)
        for ($depth = 0; $depth -lt 3; $depth++) {
            $next = New-Object System.Collections.Generic.List[string]
            foreach ($itemContent in $frontier) {
                foreach ($reference in (Get-ReviewGovernanceReferenceTokens -Content $itemContent)) {
                    if ($reference -notmatch 'workflow-review-visual-evidence|workflow-capability-evidence-matrix|quality-review-governance') { continue }

                    foreach ($candidatePath in (Get-ReviewGovernanceReferenceCandidatePaths -Reference $reference)) {
                        if (-not (Test-Path -LiteralPath $candidatePath)) { continue }
                        $resolvedPath = (Resolve-Path -LiteralPath $candidatePath).Path
                        if ($visited.ContainsKey($resolvedPath)) { continue }
                        $visited[$resolvedPath] = $true

                        $referenceContent = Get-ReviewGovernanceContent -Path $resolvedPath
                        if (Test-ReviewGovernanceReferenceContent -Content $referenceContent) { return $true }
                        if (-not [string]::IsNullOrWhiteSpace($referenceContent)) { $next.Add($referenceContent) }
                    }
                }
            }
            $frontier = @($next.ToArray())
            if ($frontier.Count -eq 0) { break }
        }

        return $false
    }

    function Test-ReviewGovernanceThinWorkflowEntryContent {
        param([string]$Content)
        if ([string]::IsNullOrWhiteSpace($Content)) { return $false }

        $hasThinEntry = (
            $Content -match 'Workflow Entry Contract' -and
            $Content -match 'Required References' -and
            $Content -match 'Workflow Entry Slimming Guard|入口瘦身防線'
        )
        $hasReviewRoute = (
            $Content -match 'quality-review-governance' -or
            (Test-ReviewGovernanceBodyOrReferenceContent -Content $Content)
        )
        $hasSharedGovernanceRoute = (
            $Content -match 'workflow-orchestration' -and
            $Content -match 'workflow-capability-evidence-matrix' -and
            $Content -match 'platform-capability-matrix'
        )
        $hasProcedureRoute = $Content -match 'workflow-stage-procedures'

        return ($hasThinEntry -and $hasReviewRoute -and $hasSharedGovernanceRoute -and $hasProcedureRoute)
    }

    $coreChecks = @(
        [PSCustomObject]@{
            Path = 'Shared\skills\quality-review-governance\SKILL.md'
            Severity = 'Red'
            Label = '審查治理共用技能缺少必要章節'
            Patterns = @(
                'Review Lifecycle States',
                'Minimum Sufficient Complexity',
                'Evidence Branch Boundary',
                'fixed-pending-validation',
                'accepted-risk'
            )
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\_index.md'
            Severity = 'Red'
            Label = '技能索引缺少審查治理路由'
            Patterns = @('quality-review-governance')
        },
        [PSCustomObject]@{
            Path = 'Shared\workflow-capability-evidence-matrix.md'
            Severity = 'Red'
            Label = '工作流矩陣缺少審查生命週期'
            Patterns = @(
                'Review Lifecycle Governance Matrix',
                'fixed-pending-validation',
                'accepted-risk',
                'blocked'
            )
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\ai-dev-quality-gate\SKILL.md'
            Severity = 'Red'
            Label = 'AI 開發品質閘門未引用審查治理'
            Patterns = @('quality-review-governance', 'Review Lifecycle Gate', 'review state')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\intent-alignment-gate\SKILL.md'
            Severity = 'Red'
            Label = '需求對齊閘門未納入審查狀態'
            Patterns = @('quality-review-governance', 'Review state|審查目的與狀態')
        },
        [PSCustomObject]@{
            Path = 'Shared\skills\delegation-strategy\SKILL.md'
            Severity = 'Red'
            Label = '委派策略未分離證據分支與審查責任'
            Patterns = @('quality-review-governance', 'Evidence branches can support', 'review lifecycle|lifecycle state|審查生命週期')
        },
        [PSCustomObject]@{
            Path = 'Shared\policies\subagent-invocation.md'
            Severity = 'Red'
            Label = '子代理政策未聲明審查狀態邊界'
            Patterns = @('quality-review-governance', '審查生命週期狀態', 'Review-state boundary')
        }
    )

    foreach ($check in $coreChecks) {
        $fullPath = Join-Path $RepoRoot $check.Path
        $content = Get-ReviewGovernanceContent -Path $fullPath
        if ($null -eq $content) {
            Add-ReviewGovernanceFinding -Severity $check.Severity `
                -File $check.Path `
                -Line 1 `
                -Reason '必要檔案不存在' `
                -Text $check.Label
            continue
        }

        $hasReferenceBackedReviewGovernance = (
            $check.Path -eq 'Shared\workflow-capability-evidence-matrix.md' -and
            (Test-ReviewGovernanceBodyOrReferenceContent -Content $content)
        )

        foreach ($pattern in $check.Patterns) {
            if ((-not $hasReferenceBackedReviewGovernance) -and ($content -notmatch $pattern)) {
                Add-ReviewGovernanceFinding -Severity $check.Severity `
                    -File $check.Path `
                    -Line 1 `
                    -Reason $check.Label `
                    -Text "missing pattern: $pattern"
            }
        }
    }

    $workflowChecks = @(
        'Codex\.agents\workflow-skills\02-blueprint-架構\SKILL.md',
        'Codex\.agents\workflow-skills\03-build-建構\SKILL.md',
        'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md',
        'Codex\.agents\workflow-skills\08-audit-健檢\SKILL.md',
        'Codex\.agents\workflow-skills\08-2-logic-深度邏輯\SKILL.md',
        'Codex\.agents\workflow-skills\08-3-report-健檢總結\SKILL.md',
        'Codex\.agents\workflow-skills\09-commit-紀錄總結\SKILL.md',
        'Codex\.agents\workflow-skills\10-routine-巡檢\SKILL.md',
        'Claude\.claude\commands\02_blueprint(架構)\SKILL.md',
        'Claude\.claude\commands\03_build(建構)\SKILL.md',
        'Claude\.claude\commands\04_fix(修復)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-2_logic\SKILL.md',
        'Claude\.claude\commands\08_audit(健檢)\08-3_report\SKILL.md',
        'Claude\.claude\commands\09_commit(紀錄)\SKILL.md',
        'Claude\.claude\commands\10_routine(巡檢)\SKILL.md',
        'Antigravity\.agents\workflows\02_blueprint(架構).md',
        'Antigravity\.agents\workflows\03_build(建構計畫).md',
        'Antigravity\.agents\workflows\04-1_fix_plan(修復計畫).md',
        'Antigravity\.agents\workflows\08_audit(健檢).md',
        'Antigravity\.agents\workflows\08-2_audit_logic(深度邏輯).md',
        'Antigravity\.agents\workflows\08-3_audit_report(健檢總結).md',
        'Antigravity\.agents\workflows\09-1_commit_scan(紀錄掃描).md',
        'Antigravity\.agents\workflows\10_routine(巡檢).md'
    )

    foreach ($relPath in $workflowChecks) {
        $fullPath = Join-Path $RepoRoot $relPath
        $content = Get-ReviewGovernanceContent -Path $fullPath
        if ($null -eq $content) {
            Add-ReviewGovernanceFinding -Severity 'Red' `
                -File $relPath `
                -Line 1 `
                -Reason '三平台工作流入口不存在' `
                -Text $relPath
            continue
        }

        $hasWorkflowReviewGovernance = (
            $content -match 'quality-review-governance' -or
            (Test-ReviewGovernanceBodyOrReferenceContent -Content $content)
        )

        if (-not $hasWorkflowReviewGovernance) {
            Add-ReviewGovernanceFinding -Severity 'Red' `
                -File $relPath `
                -Line 1 `
                -Reason '工作流入口未引用審查治理技能' `
                -Text $relPath
        }
        if (($content -notmatch 'review state|review lifecycle|review governance|審查狀態|審查治理|審查目的') -and (-not (Test-ReviewGovernanceThinWorkflowEntryContent -Content $content))) {
            Add-ReviewGovernanceFinding -Severity 'Yellow' `
                -File $relPath `
                -Line 1 `
                -Reason '工作流入口缺少可讀審查狀態語義' `
                -Text $relPath
        }
    }

    $targetAgents = Join-Path $TargetRoot '.agents'
    if (Test-Path -LiteralPath $targetAgents) {
        $targetChecks = @(
            [PSCustomObject]@{
                Path = '.agents\skills\quality-review-governance\SKILL.md'
                Patterns = @('Review Lifecycle States', 'Minimum Sufficient Complexity')
            },
            [PSCustomObject]@{
                Path = '.agents\shared\workflow-capability-evidence-matrix.md'
                Patterns = @('Review Lifecycle Governance Matrix')
            },
            [PSCustomObject]@{
                Path = '.agents\shared\policies\subagent-invocation.md'
                Patterns = @('quality-review-governance', 'Review-state boundary')
            }
        )

        foreach ($check in $targetChecks) {
            $fullPath = Join-Path $TargetRoot $check.Path
            $content = Get-ReviewGovernanceContent -Path $fullPath
            if ($null -eq $content) {
                Add-ReviewGovernanceFinding -Severity 'Yellow' `
                    -File $check.Path `
                    -Line 1 `
                    -Reason '部署後副本缺少審查治理覆蓋，需同步專案規則' `
                    -Text $check.Path
                continue
            }

            $hasReferenceBackedReviewGovernance = (
                $check.Path -eq '.agents\shared\workflow-capability-evidence-matrix.md' -and
                (Test-ReviewGovernanceBodyOrReferenceContent -Content $content)
            )

            foreach ($pattern in $check.Patterns) {
                if ((-not $hasReferenceBackedReviewGovernance) -and ($content -notmatch $pattern)) {
                    Add-ReviewGovernanceFinding -Severity 'Yellow' `
                        -File $check.Path `
                        -Line 1 `
                        -Reason '部署後副本審查治理內容過期，需同步專案規則' `
                        -Text "missing pattern: $pattern"
                }
            }
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 審查治理覆蓋（Review Governance Coverage）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：$redCount  🟡 Yellow：$yellowCount"
    foreach ($finding in $results | Sort-Object Severity, File, Reason) {
        $color = if ($finding.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
        Write-Host ("  {0} {1}:{2} — {3}" -f $finding.Severity, $finding.File, $finding.Line, $finding.Reason) -ForegroundColor $color
        if ($finding.Text) {
            Write-Host ("      {0}" -f $finding.Text) -ForegroundColor DarkGray
        }
    }

    return [PSCustomObject]@{
        Results     = @($results.ToArray())
        RedCount    = $redCount
        YellowCount = $yellowCount
        Passed      = ($redCount -eq 0)
    }
}
