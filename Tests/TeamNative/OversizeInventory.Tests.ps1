$scriptPath = Join-Path $PSScriptRoot '..\..\Scripts\Audit-SourceSize.ps1'

function New-InventoryFixtureFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][int]$LineCount
    )

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $lines = 1..$LineCount | ForEach-Object { "line $_" }
    [System.IO.File]::WriteAllLines($Path, [string[]]$lines, (New-Object System.Text.UTF8Encoding($false)))
}

Describe 'Audit-SourceSize canonical inventory' {
    BeforeEach {
        $script:fixtureOriginalLocation = Get-Location
        $script:fixtureLocationPushed = $false
        $fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("AuditSourceSize-" + [guid]::NewGuid().ToString('N'))
        $outputPath = Join-Path $fixtureRoot 'artifacts\oversize-inventory.json'
        try {
            New-Item -ItemType Directory -Path $fixtureRoot -Force | Out-Null
            Push-Location -LiteralPath $fixtureRoot
            $script:fixtureLocationPushed = $true
            & git init | Out-Null
            if ($LASTEXITCODE -ne 0) { throw 'Unable to initialize the isolated Git fixture.' }
        } catch {
            if ($script:fixtureLocationPushed) {
                Pop-Location
                $script:fixtureLocationPushed = $false
            }
            Set-Location -LiteralPath $script:fixtureOriginalLocation.Path
            if (Test-Path -LiteralPath $fixtureRoot) {
                Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
            }
            throw
        }
    }

    AfterEach {
        try {
            if ($script:fixtureLocationPushed) {
                Pop-Location
                $script:fixtureLocationPushed = $false
            }
        } finally {
            Set-Location -LiteralPath $script:fixtureOriginalLocation.Path
            if (Test-Path -LiteralPath $fixtureRoot) {
                Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
            }
        }
    }

    It 'reports canonical files at their category threshold and excludes runtime copies' {
        New-InventoryFixtureFile -Path (Join-Path $fixtureRoot 'Shared\policies\governance.md') -LineCount 350
        New-InventoryFixtureFile -Path (Join-Path $fixtureRoot '.agents\shared\policies\runtime-only.md') -LineCount 1000

        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -PassThru
        $policyItem = @($inventory.files | Where-Object { $_.path -eq 'Shared/policies/governance.md' })[0]
        $readingIndexPath = Join-Path $fixtureRoot 'artifacts\oversize-reading-index.md'

        $inventory.summary.candidateFileCount | Should Be 1
        $policyItem.type | Should Be 'shared-policy'
        (@($policyItem.thresholdReasons) -join '|') | Should Match '(^|\\|)line-count>=350($|\\|)'
        $policyItem.sourceDeployedPair.deployedPath | Should Be '.agents/shared/policies/governance.md'
        $policyItem.responsibilityClassification.automaticSplit | Should Be $false
        $policyItem.read_index.path | Should Be 'artifacts/oversize-reading-index.md'
        Test-Path -LiteralPath $outputPath | Should Be $true
        Test-Path -LiteralPath $readingIndexPath | Should Be $true

        $firstJson = Get-Content -LiteralPath $outputPath -Raw
        $firstIndex = Get-Content -LiteralPath $readingIndexPath -Raw
        & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath | Out-Null
        (Get-Content -LiteralPath $outputPath -Raw) | Should Be $firstJson
        (Get-Content -LiteralPath $readingIndexPath -Raw) | Should Be $firstIndex
    }

    It 'uses both canonical SKILL limits at 500 lines and approximately 5000 tokens' {
        New-InventoryFixtureFile -Path (Join-Path $fixtureRoot 'Shared\skills\line-limit\SKILL.md') -LineCount 500
        $tokenSkillPath = Join-Path $fixtureRoot 'Extensions\token-limit\SKILL.md'
        New-Item -ItemType Directory -Path (Split-Path -Parent $tokenSkillPath) -Force | Out-Null
        [System.IO.File]::WriteAllText($tokenSkillPath, ('x' * 20000), (New-Object System.Text.UTF8Encoding($false)))

        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -PassThru
        $lineSkill = @($inventory.files | Where-Object { $_.path -eq 'Shared/skills/line-limit/SKILL.md' })[0]
        $tokenSkill = @($inventory.files | Where-Object { $_.path -eq 'Extensions/token-limit/SKILL.md' })[0]

        $lineSkill.type | Should Be 'skill'
        (@($lineSkill.thresholdReasons) -join '|') | Should Match '(^|\\|)line-count>=500($|\\|)'
        $tokenSkill.type | Should Be 'skill'
        $tokenSkill.tokenEstimate | Should Be 5000
        (@($tokenSkill.thresholdReasons) -join '|') | Should Match '(^|\\|)token-estimate>=5000($|\\|)'
        $tokenSkill.sizeDisposition | Should Be 'skill-limit-reached'
    }

    It 'keeps untracked current candidates out of the Git baseline inventory' {
        New-InventoryFixtureFile -Path (Join-Path $fixtureRoot 'Scripts\modules\New.psm1') -LineCount 800

        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -KnownBaselineTarget @('Scripts/modules/New.psm1') -PassThru

        $inventory.summary.currentCandidateCount | Should Be 1
        $inventory.summary.baselineCandidateCount | Should Be 0
        (@($inventory.baselineCandidates)).Count | Should Be 0
        (@($inventory.untrackedKnownTargets) -contains 'Scripts/modules/New.psm1') | Should Be $true
    }

    It 'retains Git-verified baseline candidates after an authorized split' {
        $managerPath = Join-Path $fixtureRoot 'Scripts\AI-RulesManager.ps1'
        $managerTarget = 'Scripts/AI-RulesManager.ps1'
        New-InventoryFixtureFile -Path $managerPath -LineCount 924
        & git config user.email 'oversize-inventory-test@example.invalid'
        if ($LASTEXITCODE -ne 0) { throw 'Unable to configure the isolated Git fixture email.' }
        & git config user.name 'Oversize Inventory Test'
        if ($LASTEXITCODE -ne 0) { throw 'Unable to configure the isolated Git fixture user.' }
        & git add -- $managerTarget
        if ($LASTEXITCODE -ne 0) { throw 'Unable to stage the isolated Git fixture baseline.' }
        & git commit -m 'Add oversized manager baseline' | Out-Null
        if ($LASTEXITCODE -ne 0) { throw 'Unable to commit the isolated Git fixture baseline.' }

        New-InventoryFixtureFile -Path $managerPath -LineCount 59
        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -KnownBaselineTarget @($managerTarget) -PassThru
        $manager = @($inventory.baselineCandidates | Where-Object { $_.path -eq $managerTarget })[0]

        $inventory.summary.baselineCandidateCount | Should BeGreaterThan $inventory.summary.currentCandidateCount
        $inventory.summary.baselineCandidateCount | Should Be 1
        $inventory.summary.currentCandidateCount | Should Be 0
        $inventory.summary.untrackedKnownTargetCount | Should Be 0
        (@($inventory.baselineCandidates | Where-Object { $_.path -eq $managerTarget })).Count | Should Be 1
        $manager.baseline_status | Should Be 'baseline_over_budget'
        $manager.baseline_line_count | Should Be 924
        $manager.current_line_count | Should Be 59
        $manager.resolved_status | Should Be 'resolved-split'
        $manager.split_evidence.baseline_source | Should Match '^git:'
        $manager.type | Should Be 'general-source'
    }
}
