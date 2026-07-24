$scriptPath = Join-Path $PSScriptRoot '..\..\Scripts\Audit-SourceSize.ps1'

function New-ModuleBudgetFixture {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][int]$LineCount
    )

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $lines = 1..$LineCount | ForEach-Object { "function Get-Value$_ { }" }
    [System.IO.File]::WriteAllLines($Path, [string[]]$lines, (New-Object System.Text.UTF8Encoding($false)))
}

Describe 'Audit-SourceSize canonical PowerShell budgets' {
    BeforeEach {
        $fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ModuleBudget-" + [guid]::NewGuid().ToString('N'))
        $outputPath = Join-Path $fixtureRoot 'artifacts\oversize-inventory.json'
        New-Item -ItemType Directory -Path $fixtureRoot -Force | Out-Null
    }

    AfterEach {
        if (Test-Path -LiteralPath $fixtureRoot) {
            Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
        }
    }

    It 'uses the module responsibility-review threshold at 800 lines' {
        New-ModuleBudgetFixture -Path (Join-Path $fixtureRoot 'Scripts\modules\Large.psm1') -LineCount 800

        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -PassThru
        $moduleItem = @($inventory.files | Where-Object { $_.path -eq 'Scripts/modules/Large.psm1' })[0]

        $inventory.summary.candidateFileCount | Should Be 1
        $moduleItem.type | Should Be 'powershell-module'
        $moduleItem.threshold.responsibilityReviewLines | Should Be 800
        (@($moduleItem.thresholdReasons) -join '|') | Should Match '(^|\\|)line-count>=800($|\\|)'
        $moduleItem.sizeDisposition | Should Be 'size-impact-report-required'
        $moduleItem.responsibilityClassification.automaticSplit | Should Be $false
    }

    It 'classifies a non-module PowerShell script as general handwritten source' {
        New-ModuleBudgetFixture -Path (Join-Path $fixtureRoot 'Scripts\Audit.ps1') -LineCount 401

        $inventory = & $scriptPath -RepoRoot $fixtureRoot -OutputPath $outputPath -PassThru
        $scriptItem = @($inventory.files | Where-Object { $_.path -eq 'Scripts/Audit.ps1' })[0]

        $inventory.summary.candidateFileCount | Should Be 1
        $scriptItem.type | Should Be 'general-source'
        $scriptItem.threshold.responsibilityReviewLines | Should Be 401
        (@($scriptItem.thresholdReasons) -join '|') | Should Match '(^|\\|)line-count>=401($|\\|)'
        $scriptItem.sizeDisposition | Should Be 'size-impact-report-required'
        $scriptItem.read_index.primaryEntry.kind | Should Be 'function'
    }
}
