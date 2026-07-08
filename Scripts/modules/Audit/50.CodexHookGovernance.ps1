# Internal partial for Audit.psm1. Loaded by the facade only.
# Codex hook governance

$codexHookGovernanceCatalogPath = Join-Path $PSScriptRoot 'CodexHookGovernance\Catalog.ps1'
if (Test-Path -LiteralPath $codexHookGovernanceCatalogPath -PathType Leaf) {
    . $codexHookGovernanceCatalogPath
}

function Measure-CodexHookGovernance {
    <#
    .SYNOPSIS
        檢查 Codex repo-managed hooks 移除／rebuild pending 狀態，或在重建後執行完整 Team-Native hook governance 檢查。
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$TargetRoot = "."
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    $results = New-Object System.Collections.ArrayList

    function Add-CodexHookFinding {
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

    function Get-CodexHookDisplayPath {
        param([string]$Path)

        return (Get-AuditRelativePath -RepoRoot $RepoRoot -Path $Path)
    }

    function Get-CodexHookPropertyText {
        param(
            [object]$Object,
            [string]$Name
        )

        if ($null -eq $Object) { return '' }
        $property = $Object.PSObject.Properties[$Name]
        if ($null -eq $property) { return '' }
        if ($null -eq $property.Value) { return '' }
        return [string]$property.Value
    }

    function Get-CodexHookCommandText {
        param([object]$Handler)

        $texts = New-Object System.Collections.Generic.List[string]
        foreach ($propertyName in @('command', 'commandWindows')) {
            $value = Get-CodexHookPropertyText -Object $Handler -Name $propertyName
            if (-not $value) { continue }
            $texts.Add($value)

            $match = [regex]::Match($value, '(?i)-EncodedCommand\s+([A-Za-z0-9+/=]+)')
            if ($match.Success) {
                try {
                    $decoded = [Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($match.Groups[1].Value))
                    $texts.Add($decoded)
                } catch {
                    $texts.Add("encoded-command-decode-failed: $($_.Exception.Message)")
                }
            }
        }
        return (@($texts.ToArray()) -join "`n")
    }

    function Read-CodexHookConfig {
        param(
            [string]$Path,
            [string]$Label
        )

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
        try {
            return (Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop)
        } catch {
            Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $Path) -Line 1 -Reason ("Codex hook 設定不是有效 JSON ({0})" -f $Label) -Text $_.Exception.Message
            return $null
        }
    }

    function Test-CodexHookConfigDisabled {
        param([object]$Config)

        if ($null -eq $Config) { return $false }
        $lifecycleProperty = $Config.PSObject.Properties['x_ai_rules_hooks_lifecycle']
        if ($null -eq $lifecycleProperty -or $null -eq $lifecycleProperty.Value) { return $false }
        $stateProperty = $lifecycleProperty.Value.PSObject.Properties['state']
        return ($null -ne $stateProperty -and [string]$stateProperty.Value -eq 'disabled')
    }

    function Get-CodexHookCatalogEntries {
        param(
            [string]$FunctionName,
            [string]$CatalogName
        )

        if (-not (Get-Command -Name $FunctionName -ErrorAction SilentlyContinue)) {
            Add-CodexHookFinding -Severity 'Red' -File 'Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1' -Line 1 -Reason 'Codex hook governance catalog loader missing' -Text $CatalogName
            return @()
        }

        try {
            return @(& $FunctionName)
        } catch {
            Add-CodexHookFinding -Severity 'Red' -File 'Scripts/modules/Audit/CodexHookGovernance.catalog.json' -Line 1 -Reason 'Codex hook governance catalog 無法載入' -Text $_.Exception.Message
            return @()
        }
    }

    function Test-CodexHookFixtureManifestCatalogParity {
        param(
            [string]$ManifestPath,
            [object[]]$RequiredFixtureCatalog
        )

        if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) { return }

        $relative = Get-CodexHookDisplayPath -Path $ManifestPath
        try {
            $fixtureManifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        } catch {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 不是有效 JSON' -Text $_.Exception.Message
            return
        }

        $sourceCatalog = Get-CodexHookPropertyText -Object $fixtureManifest -Name 'sourceCatalog'
        if ($sourceCatalog -ne 'Scripts/modules/Audit/CodexHookGovernance.catalog.json') {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 未標示權威 catalog 來源' -Text 'sourceCatalog must point to Scripts/modules/Audit/CodexHookGovernance.catalog.json'
        }

        $manifestRequiredProperty = $fixtureManifest.PSObject.Properties['requiredFixtures']
        $manifestRequired = if ($null -eq $manifestRequiredProperty) { @() } else { @($manifestRequiredProperty.Value) }
        $catalogRequiredNames = @($RequiredFixtureCatalog | ForEach-Object { [string]$_.File } | Sort-Object)
        $manifestRequiredNames = @($manifestRequired | ForEach-Object { [string]$_.file } | Sort-Object)

        if ($manifestRequiredNames.Count -ne $catalogRequiredNames.Count) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 與 catalog required fixture 數量不一致' -Text ("manifest={0}; catalog={1}" -f $manifestRequiredNames.Count, $catalogRequiredNames.Count)
        }

        foreach ($missing in @($catalogRequiredNames | Where-Object { $manifestRequiredNames -notcontains $_ })) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 缺少 catalog required fixture' -Text $missing
        }
        foreach ($extra in @($manifestRequiredNames | Where-Object { $catalogRequiredNames -notcontains $_ })) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 含非 catalog required fixture' -Text $extra
        }

        $catalogDecisionByName = @{}
        foreach ($entry in $RequiredFixtureCatalog) {
            $catalogDecisionByName[[string]$entry.File] = [string]$entry.CanonicalDecision
        }
        foreach ($entry in $manifestRequired) {
            $fileName = [string]$entry.file
            if (-not $catalogDecisionByName.ContainsKey($fileName)) { continue }
            if ([string]$entry.canonicalDecision -ne $catalogDecisionByName[$fileName]) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture manifest 與 catalog canonicalDecision 不一致' -Text ("{0}: manifest={1}; catalog={2}" -f $fileName, $entry.canonicalDecision, $catalogDecisionByName[$fileName])
            }
        }
    }

    function Test-CodexHookConfig {
        param(
            [object]$Config,
            [string]$ConfigPath,
            [string]$Label
        )

        if ($null -eq $Config) { return }

        $relative = Get-CodexHookDisplayPath -Path $ConfigPath
        $hooksProperty = $Config.PSObject.Properties['hooks']
        if ($null -eq $hooksProperty) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook 設定缺少 hooks 根節點 ({0})" -f $Label) -Text 'missing hooks'
            return
        }

        $hooksObject = $hooksProperty.Value
        $eventNames = @($hooksObject.PSObject.Properties | ForEach-Object { $_.Name })
        if (Test-CodexHookConfigDisabled -Config $Config) {
            if ($eventNames.Count -gt 0) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook disabled 設定仍含 active handler ({0})" -f $Label) -Text ($eventNames -join ', ')
            }
            return
        }

        foreach ($topLevelProperty in $Config.PSObject.Properties) {
            if ($topLevelProperty.Name -ne 'hooks') {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex active hook 設定含非官方 top-level 欄位 ({0})" -f $Label) -Text $topLevelProperty.Name
            }
        }

        $eventCatalog = Get-CodexHookCatalogEntries -FunctionName 'Get-CodexHookSupportedEventCatalog' -CatalogName 'supportedEvents'
        $requiredEvents = @($eventCatalog | ForEach-Object { $_.EventName })
        $allowedEvents = $requiredEvents
        $expectedStatusMessages = @{}
        foreach ($event in $eventCatalog) {
            $expectedStatusMessages[$event.EventName] = $event.StatusMessage
        }

        foreach ($requiredEvent in $requiredEvents) {
            if ($eventNames -notcontains $requiredEvent) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook 缺少必要事件 ({0})" -f $Label) -Text $requiredEvent
            }
        }

        foreach ($eventProperty in $hooksObject.PSObject.Properties) {
            $eventName = $eventProperty.Name
            if ($allowedEvents -notcontains $eventName) {
                Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook 使用未登記事件 ({0})" -f $Label) -Text $eventName
            }

            $groups = @($eventProperty.Value)
            if ($groups.Count -eq 0) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook 事件缺少 handler 群組 ({0})" -f $Label) -Text $eventName
                continue
            }

            foreach ($group in $groups) {
                $hooksListProperty = $group.PSObject.Properties['hooks']
                if ($null -eq $hooksListProperty) {
                    Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook 事件缺少 hooks handler ({0})" -f $Label) -Text $eventName
                    continue
                }

                foreach ($handler in @($hooksListProperty.Value)) {
                    $type = Get-CodexHookPropertyText -Object $handler -Name 'type'
                    $command = Get-CodexHookPropertyText -Object $handler -Name 'command'
                    $commandWindows = Get-CodexHookPropertyText -Object $handler -Name 'commandWindows'
                    $statusMessage = Get-CodexHookPropertyText -Object $handler -Name 'statusMessage'
                    $commandText = Get-CodexHookCommandText -Handler $handler

                    if ($type -ne 'command') {
                        Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook handler 不是 command 類型 ({0})" -f $Label) -Text ("{0}: {1}" -f $eventName, $type)
                    }
                    if (-not $command) {
                        Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook handler 缺少 command ({0})" -f $Label) -Text $eventName
                    }
                    if (-not $commandWindows) {
                        Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook handler 缺少 Windows 命令覆寫 ({0})" -f $Label) -Text $eventName
                    }
                    if ($commandText -notmatch '\.codex[\\\/]hooks[\\\/]team-native-gate\.ps1') {
                        Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook handler 未指向 Team-Native gate 腳本 ({0})" -f $Label) -Text $eventName
                    }
                    if ($commandText -notmatch 'git\s+rev-parse\s+--show-toplevel') {
                        Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook handler 未以 git 根目錄解析專案 hook ({0})" -f $Label) -Text $eventName
                    }
                    if ($commandText -match '--dangerously-bypass-hook-trust') {
                        Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook handler 嘗試繞過 hook 信任 ({0})" -f $Label) -Text $eventName
                    }
                    if (-not $statusMessage) {
                        Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook handler 缺少狀態訊息 ({0})" -f $Label) -Text $eventName
                    } else {
                        $expectedStatusMessage = $expectedStatusMessages[$eventName]
                        if ($expectedStatusMessage -and ($statusMessage -ne $expectedStatusMessage)) {
                            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex hook statusMessage 未使用繁中治理提醒 ({0})" -f $Label) -Text ("{0}: {1}; expected {2}" -f $eventName, $statusMessage, $expectedStatusMessage)
                        }
                    }

                    $timeoutProperty = $handler.PSObject.Properties['timeout']
                    if ($null -eq $timeoutProperty) {
                        Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook handler 缺少 timeout，會落回較長預設值 ({0})" -f $Label) -Text $eventName
                    } else {
                        $timeoutValue = 0
                        if ([int]::TryParse([string]$timeoutProperty.Value, [ref]$timeoutValue)) {
                            if ($timeoutValue -gt 30) {
                                Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook timeout 過長 ({0})" -f $Label) -Text ("{0}: {1}" -f $eventName, $timeoutValue)
                            }
                        } else {
                            Add-CodexHookFinding -Severity 'Yellow' -File $relative -Line 1 -Reason ("Codex hook timeout 不是數字 ({0})" -f $Label) -Text ("{0}: {1}" -f $eventName, $timeoutProperty.Value)
                        }
                    }
                }
            }
        }
    }

    function Test-CodexAgentConfig {
        param(
            [string]$Path,
            [string]$Label
        )

        $relative = Get-CodexHookDisplayPath -Path $Path
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex config.toml missing ({0})" -f $Label) -Text 'config.toml'
            return
        }

        $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
        foreach ($required in @(
            @{ Pattern = '(?m)^\s*project_doc_fallback_filenames\s*='; Text = 'project_doc_fallback_filenames' },
            @{ Pattern = '(?m)^\s*multi_agent\s*=\s*true\s*$'; Text = 'features.multi_agent true' },
            @{ Pattern = '(?m)^\s*hooks\s*=\s*true\s*$'; Text = 'features.hooks true' },
            @{ Pattern = '(?m)^\s*max_threads\s*='; Text = 'agents.max_threads key' }
        )) {
            if ($content -notmatch $required.Pattern) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason ("Codex config.toml missing required key ({0})" -f $Label) -Text $required.Text
            }
        }
    }

    function Test-CodexHookScript {
        param(
            [string]$Path,
            [string]$Label
        )

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
        $relative = Get-CodexHookDisplayPath -Path $Path
        $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
        $decodedDisplayParts = New-Object System.Collections.Generic.List[string]
        foreach ($encodedMatch in [regex]::Matches($content, "['""](?<value>[A-Za-z0-9+/=]{8,})['""]")) {
            $encodedValue = $encodedMatch.Groups['value'].Value
            if (($encodedValue.Length % 4) -ne 0) { continue }
            try {
                $decodedValue = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedValue))
                if ($decodedValue -match '[\u4E00-\u9FFF]|Team-Native|Codex|AI_Rules') {
                    $decodedDisplayParts.Add($decodedValue)
                }
            } catch {
                continue
            }
        }
        $decodedDisplayParts.Add($content)
        $searchContent = (@($decodedDisplayParts.ToArray()) -join "`n")
        $nonAsciiMatch = [regex]::Match($content, '[^\x00-\x7F]')
        if ($nonAsciiMatch.Success) {
            $line = (($content.Substring(0, $nonAsciiMatch.Index) -split "\r?\n").Count)
            $codePoint = [int][char]$nonAsciiMatch.Value[0]
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line $line -Reason ("hook 腳本含 raw non-ASCII/CJK literal ({0})" -f $Label) -Text ("U+{0:X4}; use New-UnicodeString codepoints for non-ASCII markers" -f $codePoint)
        }

        $requiredPatterns = Get-CodexHookCatalogEntries -FunctionName 'Get-CodexHookScriptRequirementCatalog' -CatalogName 'scriptRequirements'
        foreach ($requirement in $requiredPatterns) {
            if ($searchContent -notmatch $requirement.Pattern) {
                Add-CodexHookFinding -Severity $requirement.Severity -File $relative -Line 1 -Reason ("{0} ({1})" -f $requirement.Reason, $Label) -Text $requirement.Pattern
            }
        }
    }

    function Test-CodexHookFixtureRunner {
        param([string]$Path)

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
        $relative = Get-CodexHookDisplayPath -Path $Path
        $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
        $requiredPatterns = @(
            @{ Pattern = 'transcriptText'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少臨時 transcript fixture 支援' },
            @{ Pattern = 'transcript_path'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 transcript_path 注入' },
            @{ Pattern = 'Get-FixtureShells'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 shell 矩陣探測' },
            @{ Pattern = 'Resolve-FixtureShellApplication'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 application shell 解析' },
            @{ Pattern = 'CommandType\s+Application'; Severity = 'Red'; Reason = 'Codex hook fixture runner shell 解析可能被 function/alias shadow' },
            @{ Pattern = 'StandardOutputEncoding'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 UTF-8 stdout 設定' },
            @{ Pattern = 'StandardErrorEncoding'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 UTF-8 stderr 設定' },
            @{ Pattern = 'expectedReasonCodeRegex'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少原因碼機器合約檢查' },
            @{ Pattern = 'expectedOutputRegex'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少可見輸出語意檢查' },
            @{ Pattern = 'Test-FixtureStopOutputContract'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 Stop official output contract 檢查' },
            @{ Pattern = 'Get-FixtureTrackingState'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 tracked/untracked 狀態分流' },
            @{ Pattern = 'canonicalDecision'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少 canonicalDecision taxonomy 檢查' },
            @{ Pattern = 'Test-FixtureFileHashEqual'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少來源與部署副本雜湊同步檢查' },
            @{ Pattern = 'hook source/deployed sync'; Severity = 'Red'; Reason = 'Codex hook fixture runner 缺少來源與部署副本同步成功訊息' },
            @{ Pattern = 'Remove-Item'; Severity = 'Yellow'; Reason = 'Codex hook fixture runner 缺少暫存 transcript 清理提示' }
        )
        foreach ($requirement in $requiredPatterns) {
            if ($content -notmatch $requirement.Pattern) {
                Add-CodexHookFinding -Severity $requirement.Severity -File $relative -Line 1 -Reason $requirement.Reason -Text $requirement.Pattern
            }
        }
    }

    function Test-CodexHookFixtureStructuredContract {
        param(
            [string]$Path,
            [string]$ExpectedDecision = '',
            [string]$ScenarioCodePattern = '',
            [switch]$RequireReasonCodeRegex,
            [switch]$RequireDiagnosticLabels
        )

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
        $relative = Get-CodexHookDisplayPath -Path $Path
        try {
            $fixture = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        } catch {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 不是有效 JSON' -Text $_.Exception.Message
            return
        }

        $scenarioCode = Get-CodexHookPropertyText -Object $fixture -Name 'scenarioCode'
        if (($scenarioCode -notmatch '^[A-Za-z0-9._:-]+$') -or ($ScenarioCodePattern -and ($scenarioCode -notmatch $ScenarioCodePattern))) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 ASCII scenarioCode 機器合約' -Text (Format-AuditFieldDisplay -Field 'scenarioCode')
        }

        if ($ExpectedDecision) {
            $actualDecision = Get-CodexHookPropertyText -Object $fixture -Name 'expectedDecision'
            if ($actualDecision -ne $ExpectedDecision) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 expectedDecision 機器合約' -Text ("{0}: {1}" -f (Format-AuditFieldDisplay -Field 'expectedDecision'), $ExpectedDecision)
            }
        }

        if ($RequireReasonCodeRegex) {
            $reasonCodeRegex = Get-CodexHookPropertyText -Object $fixture -Name 'expectedReasonCodeRegex'
            if (($reasonCodeRegex -notmatch '^[\x20-\x7E]+$') -or ($reasonCodeRegex -notmatch 'TN-HOOK-[A-Z0-9-]+')) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 expectedReasonCodeRegex 原因碼機器合約' -Text ("{0}: TN-HOOK-*" -f (Format-AuditFieldDisplay -Field 'expectedReasonCodeRegex'))
            }
        }

        if ($RequireDiagnosticLabels) {
            $diagnosticProperty = $fixture.PSObject.Properties['expectedDiagnosticLabels']
            if (($null -eq $diagnosticProperty) -or (-not [bool]$diagnosticProperty.Value)) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少診斷標籤機器合約' -Text ("{0}: true" -f (Format-AuditFieldDisplay -Field 'expectedDiagnosticLabels'))
            }
        }
    }

    function Test-CodexHookFixtureLayering {
        param([string]$Path)

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
        $relative = Get-CodexHookDisplayPath -Path $Path
        try {
            $fixture = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        } catch {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 不是有效 JSON' -Text $_.Exception.Message
            return
        }

        $category = Get-CodexHookPropertyText -Object $fixture -Name 'category'
        $schemaStyle = Get-CodexHookPropertyText -Object $fixture -Name 'schemaStyle'
        $decisionLayer = Get-CodexHookPropertyText -Object $fixture -Name 'decisionLayer'
        $fixtureOrigin = Get-CodexHookPropertyText -Object $fixture -Name 'fixtureOrigin'
        $expectedOutcomeKind = Get-CodexHookPropertyText -Object $fixture -Name 'expectedOutcomeKind'
        $expectedDecision = Get-CodexHookPropertyText -Object $fixture -Name 'expectedDecision'
        $expectedOutputRegex = Get-CodexHookPropertyText -Object $fixture -Name 'expectedOutputRegex'
        $canonicalDecision = Get-CodexHookPropertyText -Object $fixture -Name 'canonicalDecision'
        $fixtureName = [IO.Path]::GetFileName($Path)

        if (@('allow','advisory','deny','block','positive','negative','internal-fallback') -notcontains $category) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少分層 category' -Text 'category must be positive, negative, or internal-fallback'
        }
        if (@('official-schema-style','legacy-fallback') -notcontains $schemaStyle) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 official/fallback schemaStyle 分層' -Text 'schemaStyle must be official-schema-style or legacy-fallback'
        }
        if (@('official-output','internal-fallback') -notcontains $decisionLayer) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 internal fallback decisionLayer 分層' -Text 'decisionLayer must be official-output or internal-fallback'
        }
        if (@('synthetic','captured-synthetic') -notcontains $fixtureOrigin) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 captured/synthetic 來源分層' -Text 'fixtureOrigin must be synthetic or captured-synthetic'
        }
        if (@('allow','allow-reminder','advisory-context','advisory-would-block','deny','block') -notcontains $expectedOutcomeKind) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 expectedOutcomeKind 分層' -Text 'expectedOutcomeKind must describe allow/advisory behavior'
        }
        if ([string]::IsNullOrWhiteSpace($canonicalDecision)) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture 缺少 canonicalDecision taxonomy' -Text 'canonicalDecision must be allow, advisory, deny, or block'
        } else {
            $canonicalValues = Get-CodexHookCatalogEntries -FunctionName 'Get-CodexHookCanonicalDecisionValues' -CatalogName 'canonicalDecisionValues'
            if ($canonicalValues -notcontains $canonicalDecision) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture canonicalDecision 不在正式 taxonomy' -Text 'canonicalDecision must be allow, advisory, deny, or block'
            }

            $expectedFromDecision = if (@('allow','advisory') -contains $canonicalDecision) { 'allow' } else { $canonicalDecision }
            if ($expectedDecision -and ($expectedDecision -ne $expectedFromDecision)) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture canonicalDecision 與 expectedDecision 不一致' -Text ("canonicalDecision {0} expects expectedDecision {1}" -f $canonicalDecision, $expectedFromDecision)
            }
        }
        if ($expectedOutputRegex -and ($expectedOutputRegex -notmatch '[\u4E00-\u9FFF]')) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'Codex hook fixture expectedOutputRegex 未驗證繁中 meaning-first 內容' -Text 'expectedOutputRegex must include Chinese semantic text plus any canonical machine token'
        }

        if (($fixtureName -like 'block-*') -and ($expectedDecision -eq 'allow')) {
            if ($category -ne 'negative') {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'block-* fixture expectedDecision=allow 缺少 negative category' -Text 'block-* fixture names are negative scenarios, not official hard blocks'
            }
            if ($expectedOutcomeKind -ne 'advisory-would-block') {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'block-* fixture expectedDecision=allow 缺少 advisory-would-block 分層' -Text 'expectedDecision allow must be explained as advisory would-block behavior'
            }
            if ($decisionLayer -ne 'internal-fallback') {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'block-* fixture expectedDecision=allow 缺少 internal fallback 分層' -Text 'decision/advisory expectations are internal fallback compatibility only'
            }
        }

        $inputProperty = $fixture.PSObject.Properties['input']
        if ($null -eq $inputProperty) { return }
        $inputObject = $inputProperty.Value
        $toolName = Get-CodexHookPropertyText -Object $inputObject -Name 'tool_name'
        if ($toolName -ne 'apply_patch') { return }

        if ($schemaStyle -ne 'official-schema-style') {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'apply_patch fixture 未標示 official schema-style' -Text 'schemaStyle: official-schema-style'
        }
        $hookEventName = Get-CodexHookPropertyText -Object $inputObject -Name 'hook_event_name'
        if (-not $hookEventName) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'apply_patch fixture 缺少官方 hook_event_name 形狀' -Text 'hook_event_name'
        }
        $toolInputProperty = $inputObject.PSObject.Properties['tool_input']
        if ($null -eq $toolInputProperty) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'apply_patch fixture 缺少官方 tool_input 形狀' -Text 'tool_input.patch or tool_input.command'
        } else {
            $toolInput = $toolInputProperty.Value
            $toolInputPatch = Get-CodexHookPropertyText -Object $toolInput -Name 'patch'
            $toolInputCommand = Get-CodexHookPropertyText -Object $toolInput -Name 'command'
            if (-not ($toolInputPatch -or $toolInputCommand)) {
                Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'apply_patch fixture 缺少官方 tool_input.patch/tool_input.command' -Text 'tool_input.patch or tool_input.command'
            }
        }
        $legacyPatch = Get-CodexHookPropertyText -Object $inputObject -Name 'patch'
        $legacyCommand = Get-CodexHookPropertyText -Object $inputObject -Name 'command'
        if (-not ($legacyPatch -or $legacyCommand)) {
            Add-CodexHookFinding -Severity 'Red' -File $relative -Line 1 -Reason 'apply_patch fixture 缺少 legacy top-level fallback' -Text 'top-level patch or command must remain for fallback coverage'
        }
    }

    function Test-CodexHookSourceFileTracked {
        param([string]$Path)

        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $false }
        $relative = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $Path
        $relativeForGit = $relative -replace '\\', '/'
        $output = @(& git -C $RepoRoot ls-files -- $relativeForGit 2>$null)
        if ($LASTEXITCODE -ne 0) { return $false }
        return (($output | ForEach-Object { $_ -replace '\\', '/' } | Where-Object { $_ -eq $relativeForGit }).Count -gt 0)
    }

    $sourceConfig = Join-Path $RepoRoot 'Codex\.codex\hooks.json'
    $sourceAgentConfig = Join-Path $RepoRoot 'Codex\.codex\config.toml'
    $sourceDisabledConfig = Join-Path $RepoRoot 'Codex\.codex\hooks.delete'
    $sourceScript = Join-Path $RepoRoot 'Codex\.codex\hooks\team-native-gate.ps1'
    $targetConfig = Join-Path $TargetRoot '.codex\hooks.json'
    $targetAgentConfig = Join-Path $TargetRoot '.codex\config.toml'
    $targetDisabledConfig = Join-Path $TargetRoot '.codex\hooks.delete'
    $targetScript = Join-Path $TargetRoot '.codex\hooks\team-native-gate.ps1'
    $fixtureTest = Join-Path $RepoRoot 'Scripts\tests\codex-hooks\Invoke-CodexHookFixtureTests.ps1'
    $fixtureRoot = Join-Path $RepoRoot 'Scripts\tests\codex-hooks\fixtures'
    $sourceHookDirectory = Join-Path $RepoRoot 'Codex\.codex\hooks'
    $targetHookDirectory = Join-Path $TargetRoot '.codex\hooks'
    $fixtureTestRoot = Join-Path $RepoRoot 'Scripts\tests\codex-hooks'

    $repoManagedHookArtifacts = @(
        @{ Path = $sourceConfig; PathType = 'Leaf' },
        @{ Path = $sourceAgentConfig; PathType = 'Leaf' },
        @{ Path = $sourceDisabledConfig; PathType = 'Leaf' },
        @{ Path = $sourceHookDirectory; PathType = 'Container' },
        @{ Path = $targetConfig; PathType = 'Leaf' },
        @{ Path = $targetAgentConfig; PathType = 'Leaf' },
        @{ Path = $targetDisabledConfig; PathType = 'Leaf' },
        @{ Path = $targetHookDirectory; PathType = 'Container' },
        @{ Path = $fixtureTestRoot; PathType = 'Container' }
    )
    $hasRepoManagedHookArtifact = $false
    foreach ($artifact in $repoManagedHookArtifacts) {
        if (Test-Path -LiteralPath $artifact.Path -PathType $artifact.PathType) {
            $hasRepoManagedHookArtifact = $true
            break
        }
    }
    if (-not $hasRepoManagedHookArtifact) {
        Write-Host ""
        Write-Host "📊 掛鉤治理（Codex Hook Governance）"
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        Write-Host "ℹ️ Codex repo-managed hooks 已移除；狀態為 Hooks removed / rebuild pending"

        return [PSCustomObject]@{
            Findings       = @($results)
            Status         = 'RemovedRebuildPending'
            Skipped        = $true
            RebuildPending = $true
            RedCount       = 0
            YellowCount    = 0
            Passed         = $true
        }
    }

    $hasSourceHookConfig = Test-Path -LiteralPath $sourceConfig -PathType Leaf
    $hasSourceDisabledConfig = Test-Path -LiteralPath $sourceDisabledConfig -PathType Leaf
    $hasTargetHookConfig = Test-Path -LiteralPath $targetConfig -PathType Leaf

    $requiredHookFiles = @(
        @{ Path = $sourceAgentConfig; Label = 'source Codex config'; Severity = 'Red' },
        @{ Path = $targetAgentConfig; Label = 'project Codex config'; Severity = 'Red' },
        @{ Path = $sourceScript; Label = 'source hook script'; Severity = 'Red' },
        @{ Path = $targetScript; Label = 'project hook script'; Severity = 'Red' },
        @{ Path = $fixtureTest; Label = 'hook fixture test'; Severity = 'Yellow' },
        @{ Path = $fixtureRoot; Label = 'hook fixtures'; Severity = 'Yellow' }
    )
    if (-not ($hasSourceHookConfig -or $hasSourceDisabledConfig)) {
        $requiredHookFiles += @{ Path = $sourceConfig; Label = 'source hook config or disabled marker'; Severity = 'Red' }
    }
    if (-not $hasTargetHookConfig) {
        $requiredHookFiles += @{ Path = $targetConfig; Label = 'project hook config'; Severity = 'Red' }
    }

    foreach ($required in $requiredHookFiles) {
        $pathType = if ($required.Path -eq $fixtureRoot) { 'Container' } else { 'Leaf' }
        if (-not (Test-Path -LiteralPath $required.Path -PathType $pathType)) {
            Add-CodexHookFinding -Severity $required.Severity -File (Get-CodexHookDisplayPath -Path $required.Path) -Line 1 -Reason 'Codex hook governance 缺少必要檔案' -Text $required.Label
        }
    }

    if ($hasSourceDisabledConfig -and $hasTargetHookConfig) {
        $targetLifecycleConfig = Read-CodexHookConfig -Path $targetConfig -Label 'project lifecycle'
        if (-not (Test-CodexHookConfigDisabled -Config $targetLifecycleConfig)) {
            Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $targetConfig) -Line 1 -Reason 'Codex hook disabled marker 與 active project config 衝突' -Text 'hooks.delete may coexist only with a disabled hooks.json whose hooks object is empty'
        }
    }
    if ((Test-Path -LiteralPath $sourceConfig -PathType Leaf) -and (Test-Path -LiteralPath $targetConfig -PathType Leaf) -and (-not (Test-AuditFileHashEqual -SourcePath $sourceConfig -TargetPath $targetConfig))) {
        Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $targetConfig) -Line 1 -Reason 'Codex hook 設定部署副本與來源不一致' -Text 'Codex\.codex\hooks.json -> .codex\hooks.json'
    }
    if ((Test-Path -LiteralPath $sourceScript -PathType Leaf) -and (Test-Path -LiteralPath $targetScript -PathType Leaf) -and (-not (Test-AuditFileHashEqual -SourcePath $sourceScript -TargetPath $targetScript))) {
        Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $targetScript) -Line 1 -Reason 'Codex hook 腳本部署副本與來源不一致' -Text 'Codex\.codex\hooks\team-native-gate.ps1 -> .codex\hooks\team-native-gate.ps1'
    }

    $trackedRequiredFiles = New-Object System.Collections.Generic.List[string]
    $untrackedRequiredFixtureCount = 0
    foreach ($path in @($sourceConfig, $sourceScript, $fixtureTest)) {
        $trackedRequiredFiles.Add($path)
    }
    if (Test-Path -LiteralPath $fixtureRoot -PathType Container) {
        $fixtureManifestPath = Join-Path $fixtureRoot 'manifest.json'
        $requiredFixtureCatalog = Get-CodexHookCatalogEntries -FunctionName 'Get-CodexHookRequiredFixtureCatalog' -CatalogName 'requiredFixtures'
        Test-CodexHookFixtureManifestCatalogParity -ManifestPath $fixtureManifestPath -RequiredFixtureCatalog $requiredFixtureCatalog
        $requiredFixtureNames = @($requiredFixtureCatalog | ForEach-Object { $_.File })
        foreach ($requiredFixtureName in $requiredFixtureNames) {
            $requiredFixturePath = Join-Path $fixtureRoot $requiredFixtureName
            if (-not (Test-Path -LiteralPath $requiredFixturePath -PathType Leaf)) {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $requiredFixturePath) -Line 1 -Reason 'Codex hook usability fixture 覆蓋不足' -Text $requiredFixtureName
            }
        }

        $protectedOnlyReceiptFixture = Join-Path $fixtureRoot 'block-pretool-git-apply-no-auth.json'
        if (Test-Path -LiteralPath $protectedOnlyReceiptFixture -PathType Leaf) {
            $protectedOnlyReceiptContent = Get-Content -LiteralPath $protectedOnlyReceiptFixture -Raw -Encoding UTF8
            foreach ($requiredOnlyReceiptPattern in @(
                @{ Pattern = '"name"\s*:\s*"block-pretool-git-apply-only-receipt"'; Text = 'only receipt fixture name' },
                @{ Pattern = '"command"\s*:\s*"git apply changes\.patch"'; Text = 'command uses git apply changes.patch' },
                @{ Pattern = '"expectedOutputRegex"\s*:\s*"工具層信封或回執不是由 host/platform 驗證通道提供\.\*tool-layer envelope/receipt was not provided by host/platform verified channel"'; Text = 'only receipt fixture expects zh-first missing host verified channel rejection' },
                @{ Pattern = '"tool_execution_receipt"\s*:'; Text = 'fixture carries a trusted receipt' },
                @{ Pattern = '"trusted_issuer"\s*:\s*"codex-tool-layer"'; Text = 'receipt names trusted issuer' },
                @{ Pattern = '"receipt_source"\s*:\s*"codex-tool-layer"'; Text = 'receipt names tool-layer source' },
                @{ Pattern = '"trust_state"\s*:\s*"trusted"'; Text = 'receipt marks trusted state' },
                @{ Pattern = '"signature_state"\s*:\s*"verified"'; Text = 'receipt carries verified signature state' },
                @{ Pattern = '"nonce_state"\s*:\s*"fresh"'; Text = 'receipt carries fresh nonce state' },
                @{ Pattern = '"decision"\s*:\s*"allowed"'; Text = 'receipt decision is allowed but still insufficient alone' },
                @{ Pattern = '"target"\s*:\s*"git apply changes\.patch"'; Text = 'receipt target matches git apply changes.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_target"\s*:\s*"git apply changes\.patch"'; Text = 'protected_authorization target uses changes.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_scope"\s*:\s*"git apply changes\.patch during current fixture task"'; Text = 'protected_authorization scope uses changes.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_expiry"\s*:\s*"current task only"'; Text = 'protected_authorization current expiry' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_resolution_state"\s*:\s*"scoped"'; Text = 'protected_authorization scoped resolution' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorized_action"\s*:\s*"git apply"'; Text = 'protected_authorization authorizes git apply only' }
            )) {
                if ($protectedOnlyReceiptContent -notmatch $requiredOnlyReceiptPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedOnlyReceiptFixture) -Line 1 -Reason 'Codex hook 只有回執 protected mutation fixture 覆蓋不足' -Text $requiredOnlyReceiptPattern.Text
                }
            }
            if ($protectedOnlyReceiptContent -match '"tool_execution_envelope"\s*:') {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedOnlyReceiptFixture) -Line 1 -Reason 'Codex hook 只有回執 fixture 不應攜帶信封' -Text 'only receipt fixture must prove a trusted receipt alone is insufficient'
            }
        }

        $protectedOnlyEnvelopeFixture = Join-Path $fixtureRoot 'block-pretool-npm-install-no-auth.json'
        if (Test-Path -LiteralPath $protectedOnlyEnvelopeFixture -PathType Leaf) {
            $protectedOnlyEnvelopeContent = Get-Content -LiteralPath $protectedOnlyEnvelopeFixture -Raw -Encoding UTF8
            foreach ($requiredOnlyEnvelopePattern in @(
                @{ Pattern = '"name"\s*:\s*"block-pretool-npm-install-only-envelope"'; Text = 'only envelope fixture name' },
                @{ Pattern = '"command"\s*:\s*"npm install"'; Text = 'command uses npm install' },
                @{ Pattern = '"tool_execution_envelope"\s*:'; Text = 'fixture carries trusted envelope' },
                @{ Pattern = '"trusted_issuer"\s*:\s*"codex-tool-layer"'; Text = 'envelope names trusted issuer' },
                @{ Pattern = '"source"\s*:\s*"codex-tool-layer"'; Text = 'envelope names tool-layer source' },
                @{ Pattern = '"signature_state"\s*:\s*"verified"'; Text = 'envelope carries verified signature state' },
                @{ Pattern = '"nonce_state"\s*:\s*"fresh"'; Text = 'envelope carries fresh nonce state' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_target"\s*:\s*"npm install"'; Text = 'protected_authorization target uses npm install' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_scope"\s*:\s*"npm install during current fixture task"'; Text = 'protected_authorization scope uses npm install' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_expiry"\s*:\s*"current task only"'; Text = 'protected_authorization current expiry' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_resolution_state"\s*:\s*"scoped"'; Text = 'protected_authorization scoped resolution' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorized_action"\s*:\s*"npm install"'; Text = 'protected_authorization authorizes npm install only' }
            )) {
                if ($protectedOnlyEnvelopeContent -notmatch $requiredOnlyEnvelopePattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedOnlyEnvelopeFixture) -Line 1 -Reason 'Codex hook 只有信封 protected mutation fixture 覆蓋不足' -Text $requiredOnlyEnvelopePattern.Text
                }
            }
            if ($protectedOnlyEnvelopeContent -match '"tool_execution_receipt"\s*:') {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedOnlyEnvelopeFixture) -Line 1 -Reason 'Codex hook 只有信封 fixture 不應攜帶回執' -Text 'only envelope fixture must prove a trusted envelope alone is insufficient'
            }
        }

        $protectedApplyAllowedFixture = Join-Path $fixtureRoot 'allow-pretool-protected-git-apply-authorized.json'
        if (Test-Path -LiteralPath $protectedApplyAllowedFixture -PathType Leaf) {
            $protectedApplyAllowedContent = Get-Content -LiteralPath $protectedApplyAllowedFixture -Raw -Encoding UTF8
            foreach ($requiredApplyAllowedPattern in @(
                @{ Pattern = '"name"\s*:\s*"allow-pretool-protected-git-apply-release-patch-authorized"'; Text = 'allow git apply release.patch fixture name' },
                @{ Pattern = '"command"\s*:\s*"git apply release\.patch"'; Text = 'allow fixture command uses git apply release.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_target"\s*:\s*"git apply release\.patch"'; Text = 'allow fixture protected_authorization target uses release.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_scope"\s*:\s*"git apply release\.patch during current fixture task"'; Text = 'allow fixture protected_authorization scope uses release.patch' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorized_action"\s*:\s*"git apply"'; Text = 'allow fixture authorizes git apply only' },
                @{ Pattern = '"hostVerifiedToolLayerEvidence"\s*:\s*\{[\s\S]*"tool_execution_envelope"\s*:'; Text = 'allow fixture puts trusted envelope in host evidence root' },
                @{ Pattern = '"hostVerifiedToolLayerEvidence"\s*:\s*\{[\s\S]*"tool_execution_receipt"\s*:'; Text = 'allow fixture puts trusted receipt in host evidence root' },
                @{ Pattern = '"tool_execution_envelope"\s*:'; Text = 'allow fixture carries trusted tool execution envelope' },
                @{ Pattern = '"tool_execution_receipt"\s*:'; Text = 'allow fixture carries matching execution receipt' },
                @{ Pattern = '"envelope_id"\s*:\s*"env-protected-git-apply-authorized"'; Text = 'allow fixture uses a shared envelope id' },
                @{ Pattern = '"trusted_issuer"\s*:\s*"codex-tool-layer"'; Text = 'allow fixture names a trusted tool-layer issuer' },
                @{ Pattern = '"receipt_source"\s*:\s*"codex-tool-layer"'; Text = 'allow fixture uses a tool-layer receipt source' },
                @{ Pattern = '"trust_state"\s*:\s*"trusted"'; Text = 'allow fixture marks trust_state trusted' },
                @{ Pattern = '"signature_state"\s*:\s*"verified"'; Text = 'allow fixture carries verified signature state' },
                @{ Pattern = '"nonce_state"\s*:\s*"fresh"'; Text = 'allow fixture carries fresh nonce state' },
                @{ Pattern = '"decision"\s*:\s*"allowed"'; Text = 'allow fixture receipt decision is allowed' },
                @{ Pattern = '"target"\s*:\s*"git apply release\.patch"'; Text = 'allow fixture receipt target matches release.patch' },
                @{ Pattern = '"scope"\s*:\s*"git apply release\.patch during current fixture task"'; Text = 'allow fixture receipt scope matches protected_authorization' }
            )) {
                if ($protectedApplyAllowedContent -notmatch $requiredApplyAllowedPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedApplyAllowedFixture) -Line 1 -Reason 'Codex hook protected authorization release.patch allow fixture 覆蓋不足' -Text $requiredApplyAllowedPattern.Text
                }
            }
            if ($protectedApplyAllowedContent -match '"payload"\s*:\s*\{[\s\S]*"tool_execution_envelope"\s*:') {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedApplyAllowedFixture) -Line 1 -Reason 'Codex hook allow fixture 不可在 stdin payload 攜帶 trusted envelope' -Text 'trusted envelope must come from hostVerifiedToolLayerEvidence root'
            }
            if ($protectedApplyAllowedContent -match '"payload"\s*:\s*\{[\s\S]*"tool_execution_receipt"\s*:') {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedApplyAllowedFixture) -Line 1 -Reason 'Codex hook allow fixture 不可在 stdin payload 攜帶 trusted receipt' -Text 'trusted receipt must come from hostVerifiedToolLayerEvidence root'
            }
        }

        $protectedMismatchReceiptFixture = Join-Path $fixtureRoot 'block-pretool-protected-mutation-general-board.json'
        if (Test-Path -LiteralPath $protectedMismatchReceiptFixture -PathType Leaf) {
            $protectedMismatchReceiptContent = Get-Content -LiteralPath $protectedMismatchReceiptFixture -Raw -Encoding UTF8
            foreach ($requiredMismatchReceiptPattern in @(
                @{ Pattern = '"name"\s*:\s*"block-pretool-protected-mutation-mismatched-receipt"'; Text = 'mismatched receipt fixture name' },
                @{ Pattern = '"command"\s*:\s*"git commit -m \\"test\\""'; Text = 'command uses git commit' },
                @{ Pattern = '"hostVerifiedToolLayerEvidence"\s*:\s*\{[\s\S]*"tool_execution_envelope"\s*:'; Text = 'mismatch fixture puts envelope in host evidence root' },
                @{ Pattern = '"hostVerifiedToolLayerEvidence"\s*:\s*\{[\s\S]*"tool_execution_receipt"\s*:'; Text = 'mismatch fixture puts receipt in host evidence root' },
                @{ Pattern = '"tool_execution_envelope"\s*:'; Text = 'fixture carries trusted envelope' },
                @{ Pattern = '"tool_execution_receipt"\s*:'; Text = 'fixture carries receipt' },
                @{ Pattern = '"envelope_id"\s*:\s*"env-protected-git-commit-authorized"'; Text = 'fixture envelope id for git commit' },
                @{ Pattern = '"envelope_id"\s*:\s*"env-protected-git-commit-other"'; Text = 'fixture receipt envelope id mismatch' },
                @{ Pattern = '"decision"\s*:\s*"blocked"'; Text = 'fixture receipt decision is not allowed' },
                @{ Pattern = '"action"\s*:\s*"git push"'; Text = 'fixture receipt action mismatches git commit' },
                @{ Pattern = '"target"\s*:\s*"git push origin main"'; Text = 'fixture receipt target mismatches git commit' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorization_target"\s*:\s*"git commit -m test"'; Text = 'protected_authorization target uses git commit' },
                @{ Pattern = '"protected_authorization"\s*:\s*\{[\s\S]*"authorized_action"\s*:\s*"git commit"'; Text = 'protected_authorization authorizes git commit only' }
            )) {
                if ($protectedMismatchReceiptContent -notmatch $requiredMismatchReceiptPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $protectedMismatchReceiptFixture) -Line 1 -Reason 'Codex hook 回執 id/action/decision/scope 不匹配 fixture 覆蓋不足' -Text $requiredMismatchReceiptPattern.Text
                }
            }
        }

        $toolEnvelopeFixtureChecks = @(
            [PSCustomObject]@{
                File = 'block-command-fake-board.json'
                Reason = 'Codex hook 模型自填工具信封 block fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"block-command-fake-board"'; Text = 'existing fake-board fixture name' },
                    @{ Pattern = '"tool_execution_envelope"\s*:'; Text = 'fixture carries model-filled envelope' },
                    @{ Pattern = '"tool_execution_receipt"\s*:'; Text = 'fixture carries model-filled receipt' },
                    @{ Pattern = '"trusted_issuer"\s*:\s*"codex-tool-layer"'; Text = 'model-filled fixture looks like codex-tool-layer' },
                    @{ Pattern = '"receipt_source"\s*:\s*"codex-tool-layer"'; Text = 'model-filled receipt looks like codex-tool-layer source' },
                    @{ Pattern = '"expectedDiagnosticLabels"\s*:\s*true'; Text = 'untrusted fixture requires diagnostic labels' },
                    @{ Pattern = '工具層信封或回執不是由 host/platform 驗證通道提供.*tool-layer envelope/receipt was not provided by host/platform verified channel'; Text = 'payload-filled fixture expects zh-first host channel rejection' }
                )
            },
            [PSCustomObject]@{
                File = 'bad-input.json'
                Reason = 'Codex hook invalid payload fail-closed fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"bad-input"'; Text = 'bad-input fixture name' },
                    @{ Pattern = '"rawInput"\s*:'; Text = 'bad-input fixture uses rawInput' },
                    @{ Pattern = '無效 payload 已 fail-closed.*not valid JSON'; Text = 'bad-input fixture expects zh-first fail-closed JSON diagnostic' },
                    @{ Pattern = '"expectedDiagnosticLabels"\s*:\s*true'; Text = 'bad-input fixture requires diagnostic labels' }
                )
            },
            [PSCustomObject]@{
                File = 'block-stop-zh-completion.json'
                Reason = 'Codex hook 中文完成宣稱 Stop advisory fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"block-stop-zh-completion"'; Text = 'zh completion fixture name' },
                    @{ Pattern = '"expectedDecision"\s*:\s*"allow"'; Text = 'zh completion fixture expects Stop advisory allow decision' },
                    @{ Pattern = '"expectedReasonCodeRegex"\s*:\s*"TN-HOOK-COMPLETION-MISSING-STATION-EVIDENCE"'; Text = 'zh completion fixture expects missing station evidence reason code' },
                    @{ Pattern = '"expectedOutputRegex"\s*:\s*"完成閘門提醒\.\*不會阻擋送出\.\*Reason code: TN-HOOK-COMPLETION-MISSING-STATION-EVIDENCE"'; Text = 'zh completion fixture expects Stop advisory diagnostic wording' },
                    @{ Pattern = '"last_assistant_message"\s*:\s*"[^"]*(已完成|complete)'; Text = 'zh completion fixture carries an official assistant completion claim message' }
                )
            },
            [PSCustomObject]@{
                File = 'block-stop-missing-artifacts-complete.json'
                Reason = 'Codex hook missing artifact negative evidence Stop advisory fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"block-stop-missing-artifacts-complete"'; Text = 'missing artifacts fixture name' },
                    @{ Pattern = '"expectedDecision"\s*:\s*"allow"'; Text = 'missing artifacts fixture expects Stop advisory allow decision' },
                    @{ Pattern = '"expectedReasonCodeRegex"\s*:\s*"TN-HOOK-COMPLETION-MISSING-STATION-EVIDENCE"'; Text = 'missing artifacts fixture expects missing station evidence reason code' },
                    @{ Pattern = 'completion_state:\s*complete\.\s*change delivery artifact missing;\s*validation artifact missing;\s*review artifact missing;\s*memory/docs artifact missing;\s*completion audit missing\.\s*complete\.'; Text = 'missing artifacts fixture carries exact review payload pattern' }
                )
            },
            [PSCustomObject]@{
                File = 'allow-stop-complete-no-blockers.json'
                Reason = 'Codex hook no blockers positive evidence Stop allow fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"allow-stop-complete-no-blockers"'; Text = 'no blockers allow fixture name' },
                    @{ Pattern = '"expectedDecision"\s*:\s*"allow"'; Text = 'no blockers allow fixture expects Stop allow decision' },
                    @{ Pattern = 'no blockers in review artifact'; Text = 'no blockers allow fixture carries positive review artifact wording' },
                    @{ Pattern = 'delivery_artifact_id: cd-no-blockers-g2\.\s*change delivery artifact returned\.\s*validation_state: passed with validation artifact.*review_state: accepted with review artifact.*memory_docs_state: memory_delivery with memory/docs artifact.*completion_state: complete after completion audit'; Text = 'no blockers allow fixture carries complete positive evidence chain' }
                )
            },
            [PSCustomObject]@{
                File = 'allow-stop-zh-key-closed-with-director-risk-state.json'
                Reason = 'Codex hook 風險關閉允許 fixture 覆蓋不足'
                Patterns = @(
                    @{ Pattern = '"name"\s*:\s*"allow-stop-zh-key-closed-with-director-risk-state"'; Text = 'risk close allow fixture name' },
                    @{ Pattern = 'closed-with-director-risk'; Text = 'risk close allow fixture uses closed-with-director-risk' },
                    @{ Pattern = 'director_risk_close_evidence'; Text = 'risk close allow fixture carries explicit evidence' },
                    @{ Pattern = 'director_risk_close_scope'; Text = 'risk close allow fixture carries explicit scope' },
                    @{ Pattern = 'director_risk_close_target'; Text = 'risk close allow fixture carries explicit target' },
                    @{ Pattern = 'director_risk_close_authorization'; Text = 'risk close allow fixture carries explicit authorization' }
                )
            }
        )

        foreach ($fixtureCheck in $toolEnvelopeFixtureChecks) {
            $fixturePath = Join-Path $fixtureRoot $fixtureCheck.File
            if (-not (Test-Path -LiteralPath $fixturePath -PathType Leaf)) { continue }
            $fixtureContent = Get-Content -LiteralPath $fixturePath -Raw -Encoding UTF8
            foreach ($requiredFixturePattern in $fixtureCheck.Patterns) {
                if ($fixtureContent -notmatch $requiredFixturePattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $fixturePath) -Line 1 -Reason $fixtureCheck.Reason -Text $requiredFixturePattern.Text
                }
            }
            if (($fixtureCheck.File -eq 'block-command-fake-board.json') -and ($fixtureContent -match '"hostVerifiedToolLayerEvidence"\s*:')) {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $fixturePath) -Line 1 -Reason 'Codex hook 模型自填工具信封 block fixture 不可使用 host evidence' -Text 'fake-board fixture must keep envelope and receipt inside stdin payload only'
            }
        }

        $naturalPromptFixture = Join-Path $fixtureRoot 'allow-user-prompt.json'
        if (Test-Path -LiteralPath $naturalPromptFixture -PathType Leaf) {
            Test-CodexHookFixtureStructuredContract -Path $naturalPromptFixture -ScenarioCodePattern '(route-hint|natural)'
            $naturalPromptContent = Get-Content -LiteralPath $naturalPromptFixture -Raw -Encoding UTF8
            foreach ($requiredNaturalPromptPattern in @(
                @{ Pattern = '"expectedOutputRegex"\s*:\s*"團隊路由提醒\.\*自然語言指令可以作為有效意圖\.\*natural-language instructions are valid'; Text = 'natural-language binding context output is zh-first expected' },
                @{ Pattern = '"prompt"\s*:\s*"[^"]*GO[^"]*\u6240\u4ee5\u5462(\?|\uff1f)'; Text = 'natural-language prompt keeps GO plus follow-up wording' }
            )) {
                if ($naturalPromptContent -notmatch $requiredNaturalPromptPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $naturalPromptFixture) -Line 1 -Reason 'Codex hook 自然語言提示 fixture 覆蓋不足' -Text $requiredNaturalPromptPattern.Text
                }
            }
        }

        $zhNaturalPromptFixture = Join-Path $fixtureRoot 'allow-user-prompt-zh-natural-binding.json'
        if (Test-Path -LiteralPath $zhNaturalPromptFixture -PathType Leaf) {
            Test-CodexHookFixtureStructuredContract -Path $zhNaturalPromptFixture -ScenarioCodePattern '(route-hint|natural-binding|no-jargon)'
            $zhNaturalPromptContent = Get-Content -LiteralPath $zhNaturalPromptFixture -Raw -Encoding UTF8
            foreach ($requiredZhNaturalPromptPattern in @(
                @{ Pattern = '自然語言指令可以作為有效意圖.*natural-language instructions are valid'; Text = 'natural-language binding context output is zh-first expected' },
                @{ Pattern = '目前可見計畫或站點.*current visible plan or station'; Text = 'fixture expects zh-first visible plan or station binding guidance' },
                @{ Pattern = '檔案集合與命令.*file set.*command|檔案集合與命令.*file set / command'; Text = 'fixture expects zh-first file set and command binding guidance' },
                @{ Pattern = '不要要求總監說內部通道名稱或任務板術語.*Do not require the Director to say internal channel names or board jargon'; Text = 'fixture expects zh-first no internal jargon requirement' },
                @{ Pattern = 'Windows PowerShell \u4e2d\u6587\u63d0\u793a\uff1aGO\uff0c\u6240\u4ee5\u5462\uff1f\u56de\u53bb\u4fee\u6b63'; Text = 'zh natural-language prompt keeps exact Director wording' },
                @{ Pattern = '\\u4fee\\u525b\\u624d\\u90a3\\u500b\\u6a94\\u6848|修剛才那個檔案'; Text = 'fixture keeps daily-language GO current-file wording' }
            )) {
                if ($zhNaturalPromptContent -notmatch $requiredZhNaturalPromptPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $zhNaturalPromptFixture) -Line 1 -Reason 'Codex hook 中文自然語言提示 fixture 覆蓋不足' -Text $requiredZhNaturalPromptPattern.Text
                }
            }
        }

        $diagnosticBlockFixture = Join-Path $fixtureRoot 'block-apply-patch-no-board.json'
        if (Test-Path -LiteralPath $diagnosticBlockFixture -PathType Leaf) {
            Test-CodexHookFixtureStructuredContract -Path $diagnosticBlockFixture -ExpectedDecision 'allow' -ScenarioCodePattern '(apply-patch|structured)' -RequireReasonCodeRegex -RequireDiagnosticLabels
            $diagnosticBlockContent = Get-Content -LiteralPath $diagnosticBlockFixture -Raw -Encoding UTF8
            foreach ($requiredDiagnosticBlockPattern in @(
                @{ Pattern = '"expectedDiagnosticLabels"\s*:\s*true'; Text = 'diagnostic labels are required on an advisory write-risk fixture' },
                @{ Pattern = '"category"\s*:\s*"negative"'; Text = 'advisory write-risk fixture is categorized as negative, not a hard block' },
                @{ Pattern = '"schemaStyle"\s*:\s*"official-schema-style"'; Text = 'advisory write-risk fixture uses official schema-style' },
                @{ Pattern = '"tool_name"\s*:\s*"apply_patch"'; Text = 'advisory write-risk fixture calls apply_patch' },
                @{ Pattern = '"hook_event_name"\s*:\s*"PreToolUse"'; Text = 'advisory write-risk fixture carries hook_event_name' },
                @{ Pattern = '"tool_input"\s*:\s*\{[\s\S]*"patch"\s*:\s*"\*\*\* Begin Patch'; Text = 'advisory write-risk fixture carries tool_input.patch payload' },
                @{ Pattern = '"patch"\s*:\s*"\*\*\* Begin Patch'; Text = 'advisory write-risk fixture carries patch payload' }
            )) {
                if ($diagnosticBlockContent -notmatch $requiredDiagnosticBlockPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $diagnosticBlockFixture) -Line 1 -Reason 'Codex hook 拒絕診斷 fixture 覆蓋不足' -Text $requiredDiagnosticBlockPattern.Text
                }
            }
        }

        $postBlockFixture = Join-Path $fixtureRoot 'block-stop-zh-completion.json'
        if (Test-Path -LiteralPath $postBlockFixture -PathType Leaf) {
            Test-CodexHookFixtureStructuredContract -Path $postBlockFixture -ExpectedDecision 'allow' -ScenarioCodePattern '(completion|missing-station-evidence)' -RequireReasonCodeRegex
        }

        $captainBoundaryFixtureChecks = @(
            [PSCustomObject]@{
                File = 'context-pretool-captain-broad-read-no-board.json'
                Scenario = '(broad-read|context)'
                ExpectedDecision = 'allow'
                ReasonCode = ''
                Output = 'advisory/reminder.*禁止隊長直接產生 broad read / validation / review / external research / memory-docs / completion evidence.*允許隊長做 coordination.*named-file local_probe'
                Reason = 'Codex hook captain broad-read no-board advisory fixture 覆蓋不足'
            },
            [PSCustomObject]@{
                File = 'block-stop-missing-memory-docs.json'
                Scenario = '(memory-docs-captain|captain-substitution)'
                ExpectedDecision = 'allow'
                ReasonCode = 'TN-HOOK-MEMORY-DOCS-CAPTAIN-SUBSTITUTION'
                Output = '完成閘門提醒.*不會阻擋送出.*Reason code: TN-HOOK-MEMORY-DOCS-CAPTAIN-SUBSTITUTION'
                Reason = 'Codex hook memory/docs captain substitution Stop advisory fixture 覆蓋不足'
            },
            [PSCustomObject]@{
                File = 'block-stop-captain-broad-read-full-completion.json'
                Scenario = '(captain-substitute|substitute-completion)'
                ExpectedDecision = 'allow'
                ReasonCode = 'TN-HOOK-CAPTAIN-SUBSTITUTE-COMPLETION'
                Output = '完成閘門提醒.*不會阻擋送出.*Reason code: TN-HOOK-CAPTAIN-SUBSTITUTE-COMPLETION'
                Reason = 'Codex hook captain substitute completion Stop advisory fixture 覆蓋不足'
            }
        )
        foreach ($fixtureCheck in $captainBoundaryFixtureChecks) {
            $fixturePath = Join-Path $fixtureRoot $fixtureCheck.File
            if (-not (Test-Path -LiteralPath $fixturePath -PathType Leaf)) { continue }
            $requireReasonCode = -not [string]::IsNullOrWhiteSpace([string]$fixtureCheck.ReasonCode)
            if ($requireReasonCode) {
                Test-CodexHookFixtureStructuredContract -Path $fixturePath -ExpectedDecision $fixtureCheck.ExpectedDecision -ScenarioCodePattern $fixtureCheck.Scenario -RequireReasonCodeRegex
            } else {
                Test-CodexHookFixtureStructuredContract -Path $fixturePath -ExpectedDecision $fixtureCheck.ExpectedDecision -ScenarioCodePattern $fixtureCheck.Scenario
            }
            $fixtureContent = Get-Content -LiteralPath $fixturePath -Raw -Encoding UTF8
            $requiredPatterns = New-Object System.Collections.Generic.List[object]
            $requiredPatterns.Add(@{ Pattern = ('"expectedOutputRegex"\s*:\s*"{0}' -f [regex]::Escape($fixtureCheck.Output)); Text = $fixtureCheck.Output })
            $requiredPatterns.Add(@{ Pattern = ('"expectedDecision"\s*:\s*"{0}"' -f [regex]::Escape($fixtureCheck.ExpectedDecision)); Text = ("expectedDecision {0}" -f $fixtureCheck.ExpectedDecision) })
            if ($requireReasonCode) {
                $requiredPatterns.Add(@{ Pattern = ('"expectedReasonCodeRegex"\s*:\s*"{0}"' -f [regex]::Escape($fixtureCheck.ReasonCode)); Text = $fixtureCheck.ReasonCode })
            }
            foreach ($requiredPattern in @($requiredPatterns.ToArray())) {
                if ($fixtureContent -notmatch $requiredPattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $fixturePath) -Line 1 -Reason $fixtureCheck.Reason -Text $requiredPattern.Text
                }
            }
        }

        $blockedStateFixture = Join-Path $fixtureRoot 'allow-stop-blocked-state.json'
        if (Test-Path -LiteralPath $blockedStateFixture -PathType Leaf) {
            $blockedStateContent = Get-Content -LiteralPath $blockedStateFixture -Raw -Encoding UTF8
            foreach ($requiredBlockedStatePattern in @(
                @{ Pattern = 'completion_state:\s*blocked'; Text = 'blocked completion state remains allowed' },
                @{ Pattern = 'tool_payload_evidence_gap'; Text = 'blocked state names payload evidence gap' }
            )) {
                if ($blockedStateContent -notmatch $requiredBlockedStatePattern.Pattern) {
                    Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $blockedStateFixture) -Line 1 -Reason 'Codex hook blocked state allow fixture 覆蓋不足' -Text $requiredBlockedStatePattern.Text
                }
            }
        }

        $readonlyDeployPathFixture = Join-Path $fixtureRoot 'allow-pretool-readonly-single-file-no-board.json'
        if (Test-Path -LiteralPath $readonlyDeployPathFixture -PathType Leaf) {
            $readonlyDeployPathContent = Get-Content -LiteralPath $readonlyDeployPathFixture -Raw -Encoding UTF8
            if ($readonlyDeployPathContent -notmatch 'git diff --name-only -- Scripts/Deploy\.ps1') {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $readonlyDeployPathFixture) -Line 1 -Reason 'Codex hook 部署檔名唯讀 fixture 覆蓋不足' -Text 'read-only command mentioning Scripts/Deploy.ps1 must stay allowed'
            }
        }

        Get-ChildItem -LiteralPath $fixtureRoot -Filter '*.json' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -ne 'manifest.json' } |
            Sort-Object FullName |
            ForEach-Object {
                if ($requiredFixtureNames -contains $_.Name) {
                    $trackedRequiredFiles.Add($_.FullName)
                }
                Test-CodexHookFixtureLayering -Path $_.FullName
            }
    }

    foreach ($trackedRequired in @($trackedRequiredFiles.ToArray())) {
        if ((Test-Path -LiteralPath $trackedRequired -PathType Leaf) -and (-not (Test-CodexHookSourceFileTracked -Path $trackedRequired))) {
            $trackedRequiredRelative = Get-AuditRelativePath -RepoRoot $RepoRoot -Path $trackedRequired
            if ($trackedRequiredRelative -match '^Scripts[\\/]tests[\\/]codex-hooks[\\/]fixtures[\\/].+\.json$') {
                $untrackedRequiredFixtureCount++
                Add-CodexHookFinding -Severity 'Yellow' -File (Get-CodexHookDisplayPath -Path $trackedRequired) -Line 1 -Reason 'Codex hook fixture 已存在但尚未納入版本控制' -Text 'fixture exists in the working tree and may run locally, but release-ready is false until it is tracked'
            } else {
                Add-CodexHookFinding -Severity 'Red' -File (Get-CodexHookDisplayPath -Path $trackedRequired) -Line 1 -Reason 'Codex hook 或測試檔尚未納入版本控制' -Text 'release or clean clone may miss the Team-Native hook guard or its fixture evidence'
            }
        }
    }

    $sourceHookConfigPath = $sourceConfig
    $sourceHookConfigLabel = 'source'
    $sourceHookConfig = if ($hasSourceHookConfig) { Read-CodexHookConfig -Path $sourceHookConfigPath -Label $sourceHookConfigLabel } else { $null }
    $targetHookConfig = if ($hasTargetHookConfig) { Read-CodexHookConfig -Path $targetConfig -Label 'project' } else { $null }
    Test-CodexHookConfig -Config $sourceHookConfig -ConfigPath $sourceHookConfigPath -Label $sourceHookConfigLabel
    Test-CodexHookConfig -Config $targetHookConfig -ConfigPath $targetConfig -Label 'project'
    Test-CodexAgentConfig -Path $sourceAgentConfig -Label 'source'
    Test-CodexAgentConfig -Path $targetAgentConfig -Label 'project'
    Test-CodexHookScript -Path $sourceScript -Label 'source'
    Test-CodexHookScript -Path $targetScript -Label 'project'
    Test-CodexHookFixtureRunner -Path $fixtureTest

    $overclaimPattern = '(?i)(full runtime enforcement|complete runtime enforcement|enforces every|intercepts every|攔截所有|完整強制執行|完全防止)'
    foreach ($overclaimPath in @($sourceConfig, $sourceScript, $targetConfig, $targetScript, (Join-Path $RepoRoot 'Codex\README.md'))) {
        if (-not (Test-Path -LiteralPath $overclaimPath -PathType Leaf)) { continue }
        $content = Get-Content -LiteralPath $overclaimPath -Raw -Encoding UTF8
        if ($content -match $overclaimPattern) {
            Add-CodexHookFinding -Severity 'Yellow' -File (Get-CodexHookDisplayPath -Path $overclaimPath) -Line 1 -Reason 'Codex hook 文件或腳本含過度宣稱語句' -Text $matches[0]
        }
    }

    $redCount = ($results | Where-Object { $_.Severity -eq 'Red' }).Count
    $yellowCount = ($results | Where-Object { $_.Severity -eq 'Yellow' }).Count

    Write-Host ""
    Write-Host "📊 掛鉤治理（Codex Hook Governance）"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if ($results.Count -eq 0) {
        Write-Host "✅ Codex project-level hooks 已通過 Team-Native governance 檢查"
    } else {
        foreach ($result in $results) {
            $color = if ($result.Severity -eq 'Red') { 'Red' } else { 'Yellow' }
            Write-Host ("  [{0}] {1}:{2} — {3} :: {4}" -f $result.Severity, $result.File, $result.Line, $result.Reason, $result.Text) -ForegroundColor $color
        }
    }

    return [PSCustomObject]@{
        Findings       = @($results)
        Status         = 'Checked'
        Skipped        = $false
        RebuildPending = $false
        RedCount       = $redCount
        YellowCount    = $yellowCount
        UntrackedRequiredFixtureCount = $untrackedRequiredFixtureCount
        ReleaseReady   = (($redCount -eq 0) -and ($untrackedRequiredFixtureCount -eq 0))
        Passed         = ($redCount -eq 0)
    }
}
