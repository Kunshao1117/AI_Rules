# Internal partial for Audit.psm1. Loaded by the facade only.
# Workflow metadata, docs, platform, runtime drift

function Measure-WorkflowMetadata {
    <#
    .SYNOPSIS
        檢查三平台 workflow / command metadata v2 完整度。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $required = @(
        'author',
        'version',
        'origin',
        'kind',
        'platforms',
        'lifecycle_phase',
        'role',
        'memory_awareness',
        'tool_scope',
        'human_gate',
        'automation_safe'
    )

    $targets = @(
        [PSCustomObject]@{
            Platform = 'Codex'
            Root     = Join-Path $RepoRoot 'Codex\.agents\workflow-skills'
            Kind     = 'DirectorySkill'
        },
        [PSCustomObject]@{
            Platform = 'Claude'
            Root     = Join-Path $RepoRoot 'Claude\.claude\commands'
            Kind     = 'RecursiveSkill'
        },
        [PSCustomObject]@{
            Platform = 'Antigravity'
            Root     = Join-Path $RepoRoot 'Antigravity\.agents\workflows'
            Kind     = 'WorkflowFile'
        }
    )

    $results = @()
    foreach ($target in $targets) {
        if (-not (Test-Path $target.Root)) { continue }
        $items = if ($target.Kind -eq 'WorkflowFile') {
            Get-ChildItem -LiteralPath $target.Root -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }
        } elseif ($target.Kind -eq 'RecursiveSkill') {
            Get-ChildItem -LiteralPath $target.Root -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch '[\\/]_' }
        } else {
            Get-ChildItem -LiteralPath $target.Root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }
        }

        foreach ($item in $items) {
            $file = if ($target.Kind -eq 'WorkflowFile' -or $target.Kind -eq 'RecursiveSkill') { $item.FullName } else { Join-Path $item.FullName 'SKILL.md' }
            $name = if ($target.Kind -eq 'RecursiveSkill') {
                $item.Directory.FullName.Substring($target.Root.Length).TrimStart('\', '/')
            } else {
                $item.Name
            }
            $fm = Get-FrontmatterBlock -Path $file
            $missing = @()
            foreach ($field in $required) {
                if (-not (Test-FrontmatterField -Frontmatter $fm -Field $field)) { $missing += "metadata.$field" }
            }
            $description = Get-AuditFrontmatterFieldValue -Frontmatter $fm -Field 'description'
            $triggerIssues = New-Object System.Collections.Generic.List[string]
            if ([string]::IsNullOrWhiteSpace($description)) {
                $triggerIssues.Add('description 空白或無法解析')
            } elseif ($description.Length -lt 40) {
                $triggerIssues.Add('description 過短，可能不足以觸發自動載入')
            }
            if ($description -and (-not (Test-AuditCjkFirstReadableText -Text $description))) {
                $triggerIssues.Add('description 第一個可讀內容必須是繁中 meaning-first，不能以英文 label、when 或 Use when 開頭')
            }
            $workflowUseWhenSegment = Get-AuditDescriptionScopeSegment -Description $description -Scope 'UseWhen'
            $hasWorkflowUseWhen = ($description -match '(?is)(?:^|[.;。；]\s*)Use\s+when\s*:') -and (Test-AuditCjkFirstReadableText -Text $workflowUseWhenSegment)
            $hasChineseTriggerPhrase = $description -match '[\u3400-\u4DBF\u4E00-\u9FFF\uF900-\uFAFF].{0,80}(需要|適用|觸發|使用|執行|修復|建立|檢查|審查|驗證)'
            if (-not ($hasWorkflowUseWhen -or $hasChineseTriggerPhrase)) {
                $triggerIssues.Add('description 缺少繁中 meaning-first 觸發語句；英文 Use when/when 不可單獨作為觸發證據')
            }
            if ($description -notmatch '[\u4e00-\u9fff]') {
                $triggerIssues.Add('description 缺少繁中任務語句')
            }
            $automationSafe = $fm -match '(?m)^\s+automation_safe:\s*true\s*$'
            $status = if ($missing.Count -gt 0) {
                '🔴'
            } elseif ($triggerIssues.Count -gt 0) {
                '🟡'
            } else {
                '🟢'
            }
            $results += [PSCustomObject]@{
                Platform       = $target.Platform
                Name           = $name
                MissingFields  = $missing
                TriggerIssues  = @($triggerIssues.ToArray())
                AutomationSafe = $automationSafe
                Status         = $status
            }
        }
    }

    $passCount = ($results | Where-Object { $_.Status -eq '🟢' }).Count
    $warnCount = ($results | Where-Object { $_.Status -eq '🟡' }).Count
    $failCount = ($results | Where-Object { $_.Status -eq '🔴' }).Count
    $safeCount = ($results | Where-Object { $_.AutomationSafe }).Count

    Write-Host ""
    Write-Host "📊 工作流中繼資料（Workflow Metadata v2）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "掃描 workflow/command：$($results.Count)"
    Write-Host "🟢 完整：$passCount  🟡 觸發警告：$warnCount  🔴 缺漏：$failCount  automation-safe：$safeCount"

    foreach ($r in $results | Sort-Object Platform, Name) {
        $safeText = if ($r.AutomationSafe) { 'safe' } else { 'manual' }
        Write-Host ("{0,-12} {1,-38} {2} {3}" -f $r.Platform, $r.Name, $r.Status, $safeText)
        if ($r.MissingFields.Count -gt 0) {
            Write-Host "  ⚠ 缺少欄位：$(Format-AuditFieldListDisplay -Fields $r.MissingFields)" -ForegroundColor Yellow
        }
        if ($r.TriggerIssues.Count -gt 0) {
            Write-Host "  ⚠ 觸發品質：$($r.TriggerIssues -join '；')" -ForegroundColor Yellow
        }
    }

    return $results
}

function Measure-DocsConsistency {
    <#
    .SYNOPSIS
        檢查文件與記憶卡中的平台數、技能數與舊詞殘留。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param([string]$RepoRoot = ".")

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $counts = [PSCustomObject]@{
        SharedSkills          = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Shared\skills') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
        CodexWorkflowSkills   = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Codex\.agents\workflow-skills') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
        ClaudeCommands        = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Claude\.claude\commands') -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '[\\/]_' }).Count
        AntigravityWorkflows  = (Get-ChildItem -LiteralPath (Join-Path $RepoRoot 'Antigravity\.agents\workflows') -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^_' }).Count
    }

    $patterns = @(
        ('14' + ' 套'),
        ('雙' + ' AI'),
        ('\.Codex' + '/agents'),
        ('\.Codex' + '/commands'),
        ('\.claude/agents' + '/skills'),
        ('v1' + '\.1\.0')
    )

    $scanFiles = Get-GovernanceScanFiles -RepoRoot $RepoRoot

    $hits = @()
    foreach ($file in $scanFiles) {
        foreach ($pattern in $patterns) {
            $found = Select-String -LiteralPath $file -Pattern $pattern -CaseSensitive -ErrorAction SilentlyContinue
            foreach ($f in $found) {
                $hits += [PSCustomObject]@{
                    File    = $f.Path.Substring($RepoRoot.Length).TrimStart('\', '/')
                    Line    = $f.LineNumber
                    Pattern = $pattern
                    Text    = $f.Line.Trim()
                }
            }
        }
    }

    Write-Host ""
    Write-Host "📊 文件與記憶卡一致性"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "Shared skills：$($counts.SharedSkills)"
    Write-Host "Codex workflow skills：$($counts.CodexWorkflowSkills)"
    Write-Host "Claude commands：$($counts.ClaudeCommands)"
    Write-Host "Antigravity workflow files：$($counts.AntigravityWorkflows)"
    Write-Host "舊詞殘留：$($hits.Count)"
    foreach ($hit in $hits) {
        Write-Host "  ⚠ $($hit.File):$($hit.Line) [$($hit.Pattern)] $($hit.Text)" -ForegroundColor Yellow
    }

    return [PSCustomObject]@{
        Counts = $counts
        StaleHits = $hits
    }
}

function Measure-PlatformCapability {
    <#
    .SYNOPSIS
        檢查能力矩陣與 MCP opt-in profile 是否存在。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $matrixPath = Join-Path $RepoRoot 'Shared\platform-capability-matrix.md'
    $workflowMatrixPath = Join-Path $RepoRoot 'Shared\workflow-capability-evidence-matrix.md'
    $mcpProfilePath = Join-Path $RepoRoot 'Shared\mcp-profiles\README.md'
    $sharedRoot = Join-Path $RepoRoot 'Shared'
    $projectToolsRoot = Join-Path $sharedRoot 'project-tools'
    $targetSharedRoot = Join-Path $TargetRoot '.agents\shared'
    $targetProjectToolsRoot = Join-Path $TargetRoot '.agents\tools'
    $targetCodexSupportFiles = @(
        (Join-Path $TargetRoot '.agents\skills\_shared\_security_footer.md'),
        (Join-Path $TargetRoot '.agents\skills\_shared\_completion_gate.md')
    )
    $targetProjectToolFiles = @(
        (Join-Path $targetProjectToolsRoot 'Memory-Migration.ps1'),
        (Join-Path $targetProjectToolsRoot 'modules\Memory-Migration.psm1')
    )
    $extensionPackagePath = Join-Path $RepoRoot 'Extensions\vscode-ai-rules-manager\package.json'
    $extensionCommandsPath = Join-Path $RepoRoot 'Extensions\vscode-ai-rules-manager\src\commands.ts'
    $managerPath = Join-Path $RepoRoot 'Scripts\AI-RulesManager.ps1'

    $matrixOk = (Test-Path $matrixPath) -and ((Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'native' -and (Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'adapter' -and (Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'conditional' -and (Get-Content -LiteralPath $matrixPath -Raw -Encoding UTF8) -match 'manual')
    $workflowMatrixOk = (Test-Path $workflowMatrixPath) -and ((Get-Content -LiteralPath $workflowMatrixPath -Raw -Encoding UTF8) -match 'Workflow Matrix')
    $mcpProfileOk = (Test-Path $mcpProfilePath) -and ((Get-Content -LiteralPath $mcpProfilePath -Raw -Encoding UTF8) -match 'Opt-in')
    $projectToolSourceOk =
        (Test-Path -LiteralPath (Join-Path $projectToolsRoot 'Memory-Migration.ps1') -PathType Leaf) -and
        (Test-Path -LiteralPath (Join-Path $projectToolsRoot 'modules\Memory-Migration.psm1') -PathType Leaf)
    $memoryMigrationManagerOk = (Test-Path -LiteralPath $managerPath -PathType Leaf) -and ((Get-Content -LiteralPath $managerPath -Raw -Encoding UTF8) -match 'MemoryMigration')
    $memoryMigrationExtensionOk =
        (Test-Path -LiteralPath $extensionPackagePath -PathType Leaf) -and
        (Test-Path -LiteralPath $extensionCommandsPath -PathType Leaf) -and
        ((Get-Content -LiteralPath $extensionPackagePath -Raw -Encoding UTF8) -match 'aiRules\.memoryMigration') -and
        ((Get-Content -LiteralPath $extensionCommandsPath -Raw -Encoding UTF8) -match 'MemoryMigration')
    $targetSharedRequired =
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\skills') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\workflows') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\rules') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.codex') -PathType Container) -or
        (Test-Path -LiteralPath (Join-Path $TargetRoot '.claude') -PathType Container)
    $referenceRels = @(Get-AuditSharedGovernanceReferenceRelativePaths -SharedRoot $sharedRoot)
    $missingTargetSharedRefs = @()
    if ($targetSharedRequired) {
        foreach ($rel in $referenceRels) {
            $targetPath = Join-Path $targetSharedRoot $rel
            if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
                $missingTargetSharedRefs += $rel
            }
        }
    }
    $targetSharedOk = (-not $targetSharedRequired) -or (@($missingTargetSharedRefs).Count -eq 0)
    $targetCodexSupportRequired = Test-Path -LiteralPath (Join-Path $TargetRoot '.agents\skills') -PathType Container
    $missingCodexSupport = @()
    if ($targetCodexSupportRequired) {
        foreach ($file in $targetCodexSupportFiles) {
            if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
                $missingCodexSupport += $file
            }
        }
    }
    $targetCodexSupportOk = (-not $targetCodexSupportRequired) -or (@($missingCodexSupport).Count -eq 0)
    $targetProjectToolsRequired = $targetSharedRequired -and (-not [string]::Equals($TargetRoot, $RepoRoot, [System.StringComparison]::OrdinalIgnoreCase))
    $missingProjectTools = @()
    if ($targetProjectToolsRequired) {
        foreach ($file in $targetProjectToolFiles) {
            if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
                $missingProjectTools += $file
            }
        }
    }
    $targetProjectToolsOk = (-not $targetProjectToolsRequired) -or (@($missingProjectTools).Count -eq 0)

    Write-Host ""
    Write-Host "📊 平台能力與 MCP profile"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ("能力矩陣：{0}" -f ($(if ($matrixOk) { '🟢' } else { '🔴' })))
    Write-Host ("工作流證據矩陣：{0}" -f ($(if ($workflowMatrixOk) { '🟢' } else { '🔴' })))
    Write-Host ("共用治理參考部署：{0}" -f ($(if ($targetSharedOk) { '🟢' } else { '🔴' })))
    foreach ($rel in @($missingTargetSharedRefs | Select-Object -First 20)) {
        Write-Host ("  [缺少] .agents/shared/{0}" -f ($rel -replace '\\', '/')) -ForegroundColor Red
    }
    Write-Host ("Codex 工作流支援檔部署：{0}" -f ($(if ($targetCodexSupportOk) { '🟢' } else { '🔴' })))
    foreach ($file in @($missingCodexSupport | Select-Object -First 20)) {
        Write-Host ("  [缺少] {0}" -f (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file)) -ForegroundColor Red
    }
    Write-Host ("專案本地工具來源：{0}" -f ($(if ($projectToolSourceOk) { '🟢' } else { '🔴' })))
    Write-Host ("專案本地工具部署：{0}" -f ($(if ($targetProjectToolsOk) { '🟢' } else { '🔴' })))
    foreach ($file in @($missingProjectTools | Select-Object -First 20)) {
        Write-Host ("  [缺少] {0}" -f (Get-AuditRelativePath -RepoRoot $TargetRoot -Path $file)) -ForegroundColor Red
    }
    Write-Host ("MCP opt-in snippets：{0}" -f ($(if ($mcpProfileOk) { '🟢' } else { '🔴' })))
    Write-Host ("記憶遷移管理器入口：{0}" -f ($(if ($memoryMigrationManagerOk) { '🟢' } else { '🔴' })))
    Write-Host ("記憶遷移外掛入口：{0}" -f ($(if ($memoryMigrationExtensionOk) { '🟢' } else { '🔴' })))

    return [PSCustomObject]@{
        CapabilityMatrix        = $matrixOk
        WorkflowMatrix          = $workflowMatrixOk
        TargetSharedRefs        = $targetSharedOk
        TargetCodexSupport      = $targetCodexSupportOk
        ProjectToolSource       = $projectToolSourceOk
        TargetProjectTools      = $targetProjectToolsOk
        McpProfiles             = $mcpProfileOk
        MemoryMigrationManager  = $memoryMigrationManagerOk
        MemoryMigrationExtension = $memoryMigrationExtensionOk
    }
}

function Measure-RuntimeGlobalDrift {
    <#
    .SYNOPSIS
        檢查使用者層全域規則是否與 repo source 同步。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    .PARAMETER ProfileRoot
        使用者層設定根目錄。預設 $env:USERPROFILE，可用於 temp profile 測試。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$ProfileRoot = $env:USERPROFILE,
        [string]$TargetRoot = ".",
        [switch]$RequireTeamTrace,
        [string]$TeamTraceRoot
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    if (-not $ProfileRoot) { $ProfileRoot = $env:USERPROFILE }

    $targets = @(
        [PSCustomObject]@{
            Platform = 'Antigravity'
            Source   = Join-Path $RepoRoot 'Antigravity\global\GEMINI.md'
            Runtime  = Join-Path $ProfileRoot '.gemini\GEMINI.md'
        },
        [PSCustomObject]@{
            Platform = 'Claude'
            Source   = Join-Path $RepoRoot 'Claude\global\CLAUDE.md'
            Runtime  = Join-Path $ProfileRoot '.claude\CLAUDE.md'
        },
        [PSCustomObject]@{
            Platform = 'Codex'
            Source   = Join-Path $RepoRoot 'Codex\global\AGENTS.md'
            Runtime  = Join-Path $ProfileRoot '.codex\AGENTS.md'
        }
    )

    $dangerPattern = '(WITHOUT\s+halting|execute\s+WITHOUT|自動佈署|自動部署|\.Codex[\\/](agents|commands)[\\/]|\.claude[\\/]agents[\\/]skills[\\/]|git\s+add\s+\.|git\s+add\s+-A)'
    $results = @()

    foreach ($target in $targets) {
        if (-not (Test-Path -LiteralPath $target.Source)) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🔴'
                Severity = 'Red'
                Reason   = 'repo source 全域規則不存在'
                Runtime  = $target.Runtime
            }
            continue
        }

        if (-not (Test-Path -LiteralPath $target.Runtime)) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🟡'
                Severity = 'Yellow'
                Reason   = '使用者層全域規則尚未安裝'
                Runtime  = $target.Runtime
            }
            continue
        }

        if (Test-RuleTextEquivalent -SourcePath $target.Source -TargetPath $target.Runtime) {
            $results += [PSCustomObject]@{
                Platform = $target.Platform
                Status   = '🟢'
                Severity = 'Green'
                Reason   = '已同步'
                Runtime  = $target.Runtime
            }
            continue
        }

        $runtimeContent = Get-Content -LiteralPath $target.Runtime -Raw -Encoding UTF8
        $hasDanger = $runtimeContent -match $dangerPattern
        $reason = if ($hasDanger) {
            '使用者層規則與 source 不同，且含舊版高風險語義'
        } else {
            '使用者層規則與 source 不同'
        }

        $results += [PSCustomObject]@{
            Platform = $target.Platform
            Status   = '🟡'
            Severity = 'Yellow'
            Reason   = $reason
            Runtime  = $target.Runtime
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count
    $greenCount = ($results | Where-Object { $_.Severity -eq 'Green' }).Count

    Write-Host ""
    Write-Host "📊 執行環境全域規則漂移（Runtime Global Drift）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🟢 Green：$greenCount  🟡 Yellow：$yellowCount  🔴 Red：$redCount"
    foreach ($result in $results | Sort-Object Platform) {
        $color = switch ($result.Severity) {
            'Red' { 'Red' }
            'Yellow' { 'Yellow' }
            default { 'Green' }
        }
        Write-Host ("{0,-12} {1} {2}" -f $result.Platform, $result.Status, $result.Reason) -ForegroundColor $color
        Write-Host ("  {0}" -f $result.Runtime) -ForegroundColor DarkGray
    }

    return [PSCustomObject]@{
        Results     = $results
        GreenCount  = $greenCount
        YellowCount = $yellowCount
        RedCount    = $redCount
        Passed      = ($redCount -eq 0)
    }
}
