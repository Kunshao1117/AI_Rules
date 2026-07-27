Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Get-RequiredText {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    return Get-Text -Path $path -Label $RelativePath
}

function Get-Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Expected file is missing: $Label"
    }

    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Assert-Contains {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Expected,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not $Content.Contains($Expected)) {
        throw "$Label must contain '$Expected'."
    }
}

function Get-NormalizedPlatformCore {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Label
    )

    $content = Get-Text -Path $Path -Label $Label
    # The platform deployment flow refreshes exactly one bounded generated
    # adapter block. Compare every source-owned character outside that block.
    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    if ([regex]::Matches($content, [regex]::Escape($startMarker)).Count -ne 1 -or
        [regex]::Matches($content, [regex]::Escape($endMarker)).Count -ne 1) {
        throw "Platform core must contain one explicit generated-policy marker range: $Label"
    }

    $start = $content.IndexOf($startMarker, [System.StringComparison]::Ordinal)
    $end = $content.IndexOf($endMarker, $start, [System.StringComparison]::Ordinal)
    if ($start -lt 0 -or $end -lt $start) {
        throw "Platform core has an invalid generated-policy marker range: $Label"
    }

    $end += $endMarker.Length
    $content = $content.Remove($start, $end - $start).Insert($start, '<!-- generated shared policy omitted -->')
    return ($content -replace "`r`n", "`n").Trim()
}

function Get-NormalizedText {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Label
    )

    # Deployment can preserve a source file while normalizing its line endings.
    # Compare text after that transport-only normalization; all other characters
    # must still match exactly.
    return ((Get-Text -Path $Path -Label $Label) -replace "`r`n", "`n")
}

Describe 'Non-engineer UX contract' {
    BeforeAll {
        $script:readme = Get-RequiredText 'README.md'
        $script:languagePolicy = Get-RequiredText 'Shared\policies\language-governance.md'
        $script:outputExamples = Get-RequiredText 'Shared\policies\references\user-facing-output-examples.md'
        $script:changelog = Get-RequiredText 'CHANGELOG.md'
        $script:runtimeTarget = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-non-engineer-ux-" + [guid]::NewGuid().ToString())
        $Error.Clear()
        $global:LASTEXITCODE = 0
        & (Join-Path $repoRoot 'Scripts\Deploy.ps1') -Platform All -Mode Fresh -Target $script:runtimeTarget
        if ($LASTEXITCODE -ne 0) {
            throw "Fresh runtime deployment for UX parity exited with code $LASTEXITCODE."
        }
        if ($Error.Count -ne 0) {
            $messages = $Error | ForEach-Object { $_.ToString() }
            throw "Fresh runtime deployment for UX parity produced uncaught error records: $($messages -join ' | ')"
        }
    }

    AfterAll {
        if ($script:runtimeTarget -and (Test-Path -LiteralPath $script:runtimeTarget)) {
            Remove-Item -LiteralPath $script:runtimeTarget -Recurse -Force -ErrorAction Stop
        }
    }

    It 'keeps the README first layer focused on non-engineers before technical detail' {
        $firstLayerEnd = $readme.IndexOf('## 進階資料')
        if ($firstLayerEnd -lt 0) {
            throw 'README must provide a clear advanced-information boundary.'
        }

        $firstLayer = $readme.Substring(0, $firstLayerEnd)
        foreach ($requiredSection in @(
                '## 一句話定位',
                '## 適合誰',
                '## 它實際幫你避免什麼',
                '## 五分鐘開始',
                '## AI 會如何回報',
                '## 安全與能力邊界',
                '## 支援平台'
            )) {
            Assert-Contains -Content $firstLayer -Expected $requiredSection -Label 'README first layer'
        }

        $firstLayer | Should Not Match '(?m)^```'
        $firstLayer | Should Not Match 'Team-Native|Agent Governance|Handoff|Artifact|Sandbox|Hook'
    }

    It 'keeps the minimum Traditional Chinese user-facing core and status distinctions in the canonical policy' {
        foreach ($requiredRule in @(
                '### Minimum Traditional Chinese User-Facing Core',
                '所有使用者可見內容預設使用白話繁體中文。',
                '已開始、已派工、已修改、已驗證、已完成與已發布必須分開表達，不得互相代替。',
                '`已驗證` means the named check passed',
                '`驗證未通過`',
                '`已提交` means the named source state was recorded in Git',
                '`已發布` means the named version or package became available',
                '`已部署` means the named version or revision reached the stated runtime',
                'separate authorization and platform delivery evidence.',
                '### Beginner Readability Check',
                '現在是否完成？',
                '實際改變了什麼？',
                '是否有需要知道的風險或未完成事項？',
                '現在是否需要自己做決定或採取行動？',
                'Shared/policies/references/user-facing-output-examples.md'
            )) {
            Assert-Contains -Content $languagePolicy -Expected $requiredRule -Label 'Language governance policy'
        }

        foreach ($requiredRule in @(
                '# Representative User-Facing Examples',
                '小型修改已完成並驗證',
                '已修改但尚未驗證',
                '因缺少授權而受阻',
                '驗證失敗，需要修正',
                '指定驗證未通過',
                '需要使用者在兩個有實際影響的選項中決定',
                '已完成來源工作，但尚未提交、發布或部署',
                '技術錯誤很多，但使用者第一層只需要知道原因與下一步'
            )) {
            Assert-Contains -Content $outputExamples -Expected $requiredRule -Label 'User-facing output examples'
        }
    }

    It 'keeps the always-on user-facing core short and points each platform to the canonical policy' {
        $platformCores = @(
            'Antigravity\.agents\rules\00_core_identity.md',
            'Claude\.claude\rules\core-identity.md',
            'Codex\.codex\AGENTS.md'
        )

        foreach ($relativePath in $platformCores) {
            $content = Get-RequiredText $relativePath
            Assert-Contains -Content $content -Expected '所有使用者可見內容預設使用白話繁體中文。' -Label $relativePath
            Assert-Contains -Content $content -Expected '已開始、已派工、已修改、已驗證、已完成與已發布必須分開表達，不得互相代替。' -Label $relativePath
            Assert-Contains -Content $content -Expected 'Shared/policies/language-governance.md' -Label $relativePath
            $content | Should Not Match '### Technical Detail Boundary|### Representative User-Facing Examples|完整術語字典'
        }
    }

    It 'keeps passed validation and source, release, and deployment states distinct for readers' {
        foreach ($requiredText in @(
                '**已驗證**：指定檢查已通過',
                '「驗證未通過」',
                '**已提交**：這次來源變更已寫入版本紀錄',
                '**已發布**：指定版本已在說明的發行位置提供取得',
                '**已部署**：指定版本已送到說明的執行環境'
            )) {
            Assert-Contains -Content $readme -Expected $requiredText -Label 'README state distinction'
        }
    }

    It 'keeps source and freshly deployed runtime copies equal for the affected always-on surfaces' {
        foreach ($pair in @(
                @{ Source = 'Antigravity\.agents\rules\00_core_identity.md'; Runtime = '.agents\rules\00_core_identity.md' },
                @{ Source = 'Claude\.claude\rules\core-identity.md'; Runtime = '.claude\rules\core-identity.md' },
                @{ Source = 'Codex\.codex\AGENTS.md'; Runtime = '.codex\AGENTS.md' }
            )) {
            $sourcePath = Join-Path $repoRoot $pair.Source
            $runtimePath = Join-Path $script:runtimeTarget $pair.Runtime
            if ((Get-NormalizedPlatformCore -Path $sourcePath -Label $pair.Source) -cne (Get-NormalizedPlatformCore -Path $runtimePath -Label $pair.Runtime)) {
                throw "Source/runtime UX parity failed outside the generated adapter block: $($pair.Source)"
            }
        }

        $sourcePolicy = Join-Path $repoRoot 'Shared\policies\language-governance.md'
        $runtimePolicy = Join-Path $script:runtimeTarget '.agents\shared\policies\language-governance.md'
        if ((Get-NormalizedText -Path $sourcePolicy -Label 'Shared\policies\language-governance.md') -cne (Get-NormalizedText -Path $runtimePolicy -Label '.agents\shared\policies\language-governance.md')) {
            throw 'Source/runtime UX parity failed: Shared language-governance policy.'
        }

        $sourceExamples = Join-Path $repoRoot 'Shared\policies\references\user-facing-output-examples.md'
        $runtimeExamples = Join-Path $script:runtimeTarget '.agents\shared\policies\references\user-facing-output-examples.md'
        if ((Get-NormalizedText -Path $sourceExamples -Label 'Shared\policies\references\user-facing-output-examples.md') -cne (Get-NormalizedText -Path $runtimeExamples -Label '.agents\shared\policies\references\user-facing-output-examples.md')) {
            throw 'Source/runtime UX parity failed: representative user-facing examples.'
        }
    }

    It 'records the full reverse-order rollback for the phase-one migration dependency chain' {
        foreach ($commit in @('2c0b313f', '7c48f8c3', '88587eda')) {
            Assert-Contains -Content $changelog -Expected "git revert --no-edit $commit" -Label 'Phase-one rollback record'
        }

        $testCommit = $changelog.IndexOf('git revert --no-edit 2c0b313f')
        $checkpointCommit = $changelog.IndexOf('git revert --no-edit 7c48f8c3')
        $coreCommit = $changelog.IndexOf('git revert --no-edit 88587eda')
        if ($testCommit -ge $checkpointCommit -or $checkpointCommit -ge $coreCommit) {
            throw 'Phase-one rollback commands must appear in reverse dependency order.'
        }
    }

    It 'keeps a minimal Windows governance CI separate from the release workflow' {
        $workflow = Get-RequiredText '.github\workflows\governance.yml'
        foreach ($requiredContent in @(
                'pull_request:',
                'push:',
                'windows-latest',
                'shell: pwsh',
                'fetch-depth: 0',
                'Test-TeamNativeV2.ps1',
                'git diff --check',
                'git status --porcelain',
                '$Error.Count'
            )) {
            Assert-Contains -Content $workflow -Expected $requiredContent -Label 'Governance CI workflow'
        }
    }

    It 'keeps Antigravity runtime context behavior explicitly unverified locally' {
        Assert-Contains -Content $readme -Expected 'Antigravity Runtime Context 行為目前只有官方文件描述，尚未在本機驗證。' -Label 'README boundary'
        $readme | Should Not Match 'Antigravity Runtime Context 行為已在本機驗證。|Antigravity Runtime Context 行為已在本機證實。'
    }
}
