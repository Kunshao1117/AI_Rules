Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$script:codexModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1') -Force -PassThru
$script:managerModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Manager.Deployment.psm1') -Force -PassThru

function Assert-CodexGeneratedPolicyPointer {
    param(
        [string]$Path,
        [string]$Stage
    )

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($content -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') {
        throw "$Stage did not retain the generated Codex policy pointer."
    }
    if ($content -notmatch 'Shared/policies/adapters/codex-subagent-invocation\.md') {
        throw "$Stage did not identify the Codex adapter policy source."
    }
    if ($content -match 'The governed Codex candidate rungs are exactly') {
        throw "$Stage copied the full Codex adapter policy into AGENTS.md."
    }
}

function Get-ManagerSyncResultFromOutput {
    param([object[]]$Output)

    $results = @($Output | Where-Object {
        $null -ne $_ -and $null -ne $_.PSObject.Properties['RequiredStageResults']
    })
    if ($results.Count -ne 1) {
        throw "Expected one manager sync result object; received $($results.Count)."
    }
    return $results[0]
}

function Invoke-CodexModuleCommand {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Command,
        [object[]]$ArgumentList
    )

    & $script:codexModule $Command @ArgumentList
}

Describe 'Codex Fresh, Upgrade, and Manager adapter policy regression' {
    BeforeEach {
        $script:tempTarget = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-codex-platform-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempTarget | Out-Null
        Mock -CommandName Assert-ManagerSourceSyncedForProjectSync -ModuleName $script:managerModule.Name -MockWith { }
        $global:aiRulesCodexConfirmGateCalls = 0
        & $script:codexModule {
            Set-Item -Path Function:Invoke-ConfirmGate -Value {
                $global:aiRulesCodexConfirmGateCalls += 1
                return $true
            }
        }
    }

    AfterEach {
        try {
            if (Test-Path -LiteralPath $script:tempTarget) {
                Remove-Item -LiteralPath $script:tempTarget -Recurse -Force
            }
        } finally {
            Remove-Variable -Name aiRulesCodexConfirmGateCalls -Scope Global -ErrorAction SilentlyContinue
            if (Test-Path -LiteralPath $script:tempTarget) {
                throw "Temporary Codex fixture was not removed: $script:tempTarget"
            }
        }
    }

    It 'uses the Codex adapter marker through Fresh, repeated Upgrade, and repeated Manager Sync' {
        if ($script:tempTarget -match '(?i)D:\\MXF_TOOL|globalStorage') {
            throw "Temporary Codex fixture must not use a managed cache path: $script:tempTarget"
        }

        foreach ($sourcePath in @(
            (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Manager.Deployment.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Manager.ProjectSync.psm1'),
            (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1')
        )) {
            $sourceContent = Get-Content -LiteralPath $sourcePath -Raw -Encoding UTF8
            if ($sourceContent -match '(?i)D:\\MXF_TOOL|globalStorage') {
                throw "Safe Codex path source must not use managed cache storage: $sourcePath"
            }
        }

        $frameworkRoot = Join-Path $repoRoot 'Codex'
        $sharedSkillsRoot = Join-Path $repoRoot 'Shared\skills'
        $adapterPolicyPath = Join-Path $repoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $agentsPath = Join-Path $script:tempTarget '.codex\AGENTS.md'
        $adapterContent = Get-Content -LiteralPath $adapterPolicyPath -Raw -Encoding UTF8
        if ($adapterContent -notmatch '<!-- SUBAGENT_POLICY:CODEX_START -->' -or
            $adapterContent -notmatch '<!-- SUBAGENT_POLICY:CODEX_END -->') {
            throw 'The Codex adapter source must expose its platform marker.'
        }

        $null = Invoke-CodexModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CodexFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Fresh'
        foreach ($legacyHookPath in @(
            '.codex\hooks.json',
            '.codex\hooks\team-native-gate.ps1',
            '.codex\hooks\team-native-launcher.ps1'
        )) {
            if (Test-Path -LiteralPath (Join-Path $script:tempTarget $legacyHookPath)) {
                throw "Fresh installed a legacy Team-Native hook artifact: $legacyHookPath"
            }
        }

        $null = Invoke-CodexModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CodexUpgrade -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'First Upgrade'
        $firstUpgradeContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $firstUpgradeHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash

        $null = Invoke-CodexModuleCommand -Command {
            param($FrameworkRoot, $Target, $SharedSkillsRoot)
            Invoke-CodexUpgrade -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        } -ArgumentList @($frameworkRoot, $script:tempTarget, $sharedSkillsRoot)
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Second Upgrade'
        $secondUpgradeContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $secondUpgradeHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash
        if ($firstUpgradeContent -cne $secondUpgradeContent -or $firstUpgradeHash -ne $secondUpgradeHash) {
            throw 'The second Codex Upgrade materially changed AGENTS.md.'
        }
        if ($global:aiRulesCodexConfirmGateCalls -ne 2) {
            throw "Expected two Codex upgrade confirmation checks; received $global:aiRulesCodexConfirmGateCalls."
        }

        $firstManagerOutput = @(Invoke-ManagerSyncProjectRules -RepoRoot $repoRoot -Target $script:tempTarget -ProjectPlatform Codex -Apply 6>&1)
        $firstManagerResult = Get-ManagerSyncResultFromOutput -Output $firstManagerOutput
        if (-not $firstManagerResult.Succeeded) { throw 'The first Manager SyncProjectRules run failed.' }
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'First Manager Sync'
        $firstManagerContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $firstManagerHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash

        $secondManagerOutput = @(Invoke-ManagerSyncProjectRules -RepoRoot $repoRoot -Target $script:tempTarget -ProjectPlatform Codex -Apply 6>&1)
        $secondManagerResult = Get-ManagerSyncResultFromOutput -Output $secondManagerOutput
        if (-not $secondManagerResult.Succeeded) { throw 'The second Manager SyncProjectRules run failed.' }
        Assert-CodexGeneratedPolicyPointer -Path $agentsPath -Stage 'Second Manager Sync'
        $secondManagerContent = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
        $secondManagerHash = (Get-FileHash -LiteralPath $agentsPath -Algorithm SHA256).Hash
        if ($firstManagerContent -cne $secondManagerContent -or $firstManagerHash -ne $secondManagerHash) {
            throw 'The second Manager SyncProjectRules run materially changed AGENTS.md.'
        }
    }

    It 'retires only hash-owned legacy Team hooks and preserves a modified set' {
        $artifactContent = [ordered]@{
            'hooks.json' = '{"hooks":{}}'
            'hooks/team-native-gate.ps1' = 'Write-Output gate'
            'hooks/team-native-launcher.ps1' = 'Write-Output launcher'
        }

        function New-LegacyHookFixture {
            param([string]$Root)

            $codexRoot = Join-Path $Root '.codex'
            foreach ($entry in $artifactContent.GetEnumerator()) {
                $path = Join-Path $codexRoot ($entry.Key -replace '/', '\\')
                $parent = Split-Path $path -Parent
                New-Item -ItemType Directory -Force -Path $parent | Out-Null
                [System.IO.File]::WriteAllText($path, $entry.Value, [System.Text.UTF8Encoding]::new($false))
            }

            return @($artifactContent.Keys | ForEach-Object {
                $path = Join-Path $codexRoot ($_ -replace '/', '\\')
                [PSCustomObject]@{
                    RelativePath = $_
                    Sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
                }
            })
        }

        $managedRoot = Join-Path $script:tempTarget 'managed-legacy-hooks'
        $managedArtifacts = New-LegacyHookFixture -Root $managedRoot
        $previewOutput = @(Invoke-CodexModuleCommand -Command {
            param($TargetRoot, $ManagedArtifacts)
            Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $TargetRoot -ManagedArtifacts $ManagedArtifacts
        } -ArgumentList @($managedRoot, $managedArtifacts) 6>&1)
        $preview = @($previewOutput | Where-Object { $null -ne $_ -and $null -ne $_.PSObject.Properties['WouldRemoveCount'] })
        if ($preview.Count -ne 1 -or $preview[0].WouldRemoveCount -ne 3) {
            throw 'Managed legacy hook preview did not identify the complete set.'
        }
        if (($previewOutput | Out-String) -notmatch 'would_remove_managed_legacy_hook') {
            throw 'Managed legacy hook dry-run did not report planned removal.'
        }
        $applied = Invoke-CodexModuleCommand -Command {
            param($TargetRoot, $ManagedArtifacts)
            Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $TargetRoot -ManagedArtifacts $ManagedArtifacts -Apply
        } -ArgumentList @($managedRoot, $managedArtifacts)
        if ($applied.WouldRemoveCount -ne 3) {
            throw 'Managed legacy hook cleanup did not report the complete removed set.'
        }
        foreach ($relativePath in $artifactContent.Keys) {
            if (Test-Path -LiteralPath (Join-Path $managedRoot ('.codex\\' + ($relativePath -replace '/', '\\')))) {
                throw "Managed legacy hook cleanup left an artifact behind: $relativePath"
            }
        }

        $modifiedRoot = Join-Path $script:tempTarget 'modified-legacy-hooks'
        $modifiedArtifacts = New-LegacyHookFixture -Root $modifiedRoot
        $modifiedGatePath = Join-Path $modifiedRoot '.codex\hooks\team-native-gate.ps1'
        [System.IO.File]::AppendAllText($modifiedGatePath, "`n# user change", [System.Text.UTF8Encoding]::new($false))
        $modifiedPreviewOutput = @(Invoke-CodexModuleCommand -Command {
            param($TargetRoot, $ManagedArtifacts)
            Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $TargetRoot -ManagedArtifacts $ManagedArtifacts
        } -ArgumentList @($modifiedRoot, $modifiedArtifacts) 6>&1)
        $modifiedPreview = @($modifiedPreviewOutput | Where-Object { $null -ne $_ -and $null -ne $_.PSObject.Properties['WouldPreserveCount'] })
        if ($modifiedPreview.Count -ne 1 -or $modifiedPreview[0].WouldPreserveCount -ne 3) {
            throw 'Modified legacy hook set was not preserved as a single transaction.'
        }
        if (($modifiedPreviewOutput | Out-String) -notmatch 'would_preserve_user_modified_hook') {
            throw 'Modified legacy hook dry-run did not report manual action.'
        }
        $null = Invoke-CodexModuleCommand -Command {
            param($TargetRoot, $ManagedArtifacts)
            Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $TargetRoot -ManagedArtifacts $ManagedArtifacts -Apply
        } -ArgumentList @($modifiedRoot, $modifiedArtifacts)
        foreach ($relativePath in $artifactContent.Keys) {
            if (-not (Test-Path -LiteralPath (Join-Path $modifiedRoot ('.codex\\' + ($relativePath -replace '/', '\\'))))) {
                throw "Modified legacy hook cleanup removed a user-owned artifact: $relativePath"
            }
        }
    }
}
