Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$windowsPowerShellPath = if ($env:WINDIR) {
    Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
} else {
    $null
}
$windowsPowerShellAvailable = $null -ne $windowsPowerShellPath -and (Test-Path -LiteralPath $windowsPowerShellPath -PathType Leaf)

Describe 'Windows PowerShell 5.1 manager parser and module composition compatibility' {
    It 'parses the manager entry chain and composes consumer modules without invoking SyncProjectRules' -Skip:(-not $windowsPowerShellAvailable) {
        $childScript = @'
$ErrorActionPreference = 'Stop'
$repoRoot = '__REPO_ROOT__'

try {
    if ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion.Major -ne 5 -or $PSVersionTable.PSVersion.Minor -ne 1) {
        throw "Expected Windows PowerShell 5.1 Desktop, received $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion)."
    }

    $parseTargets = @(
        'Scripts\AI-RulesManager.ps1',
        'Scripts\modules\Manager.Commands.psm1',
        'Scripts\modules\Manager.Deployment.psm1',
        'Scripts\modules\Manager.ProjectSync.psm1',
        'Scripts\modules\Manager.Config.psm1',
        'Scripts\modules\Skills-Sync.psm1',
        'Scripts\modules\Core.Reporting.psm1',
        'Scripts\modules\Core.Upgrade.psm1',
        'Scripts\modules\Core.Infrastructure.psm1',
        'Scripts\modules\Core.Cleanup.psm1',
        'Scripts\modules\Core.Gitignore.psm1',
        'Scripts\modules\Core.ProjectSkills.psm1'
    )

    foreach ($relativePath in @(
        'Scripts\modules\Manager.Deployment.psm1',
        'Scripts\modules\Manager.ProjectSync.psm1'
    )) {
        $path = Join-Path $repoRoot $relativePath
        $bytes = [System.IO.File]::ReadAllBytes($path)
        if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF) {
            throw "Expected UTF-8 BOM for Windows PowerShell 5.1 manager source: $relativePath"
        }
    }

    foreach ($relativePath in $parseTargets) {
        $path = Join-Path $repoRoot $relativePath
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Expected parser target is missing: $relativePath"
        }

        $tokens = $null
        $parseErrors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors)
        if ($parseErrors -and $parseErrors.Count -gt 0) {
            $diagnostics = @(
                $parseErrors | ForEach-Object {
                    '{0}:{1}:{2}: {3}' -f $_.Extent.File, $_.Extent.StartLineNumber, $_.Extent.StartColumnNumber, $_.Message
                }
            ) -join [Environment]::NewLine
            throw "Parser.ParseFile failed for ${relativePath}:`n$diagnostics"
        }
    }

    function Assert-ConsumerModuleComposition {
        param(
            [string]$RelativePath,
            [string[]]$RequiredCommands
        )

        $module = Import-Module -Name (Join-Path $repoRoot $RelativePath) -Force -PassThru -ErrorAction Stop
        if (-not $module) {
            throw "Direct import did not return module information: $RelativePath"
        }

        $missingCommands = @(& $module {
            param([string[]]$CommandNames)
            foreach ($commandName in $CommandNames) {
                if (-not (Get-Command -Name $commandName -ErrorAction SilentlyContinue)) {
                    $commandName
                }
            }
        } $RequiredCommands)

        if ($missingCommands.Count -gt 0) {
            throw "Direct import left required sibling commands unavailable in ${RelativePath}: $($missingCommands -join ', ')"
        }

        return $module
    }

    $upgradeModule = Assert-ConsumerModuleComposition -RelativePath 'Scripts\modules\Core.Upgrade.psm1' -RequiredCommands @('Compare-FrameworkFile', 'Write-Ok')
    $upgradeReport = @(& $upgradeModule {
        param(
            [string]$SourceRoot,
            [string]$TargetRoot
        )

        Get-UpgradeReport -SourceRoot $SourceRoot -TargetRoot $TargetRoot -ScanDirs @() -ProtectedDirs @() -ScanFiles @('Scripts\modules\Core.Upgrade.psm1')
    } $repoRoot $repoRoot)

    if ($upgradeReport.Count -ne 1 -or $upgradeReport[0].Status -ne 'SAME') {
        $statuses = @($upgradeReport | ForEach-Object { $_.Status }) -join ', '
        throw "Core.Upgrade module-scope Get-UpgradeReport did not return exactly one SAME result: $statuses"
    }

    $consumerModuleRequirements = @(
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Core.Comparison.psm1'; RequiredCommands = @('Write-Ok', 'Write-Step', 'Write-Warn') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Core.Cleanup.psm1'; RequiredCommands = @('Write-Ok', 'Write-Step', 'Write-Warn') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Core.Gitignore.psm1'; RequiredCommands = @('Write-Ok', 'Write-Step', 'Write-AiRulesGitignoreReport') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Core.Infrastructure.psm1'; RequiredCommands = @('Write-Ok', 'Write-Step') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Core.ProjectSkills.psm1'; RequiredCommands = @('Write-Ok', 'Write-Step', 'Write-Warn') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Skills-Sync.psm1'; RequiredCommands = @('Compare-FrameworkFile', 'Write-Ok', 'Write-Step', 'Write-Warn') },
        [PSCustomObject]@{ RelativePath = 'Scripts\modules\Manager.ProjectSync.psm1'; RequiredCommands = @('Compare-FrameworkFile', 'Get-UpgradeReport', 'Merge-ManagerCodexProjectConfigDefaults', 'Write-Ok', 'Write-Step', 'Write-Warn') }
    )

    foreach ($consumerModuleRequirement in $consumerModuleRequirements) {
        $null = Assert-ConsumerModuleComposition -RelativePath $consumerModuleRequirement.RelativePath -RequiredCommands $consumerModuleRequirement.RequiredCommands
    }

    $projectSyncModule = Import-Module -Name (Join-Path $repoRoot 'Scripts\modules\Manager.ProjectSync.psm1') -Force -PassThru -ErrorAction Stop
    $projectSyncExports = @($projectSyncModule.ExportedCommands.Keys | Sort-Object)
    if ($projectSyncExports.Count -ne 1 -or $projectSyncExports[0] -ne 'Invoke-ManagerProjectRulesSync') {
        throw "Manager.ProjectSync must export only Invoke-ManagerProjectRulesSync; received: $($projectSyncExports -join ', ')"
    }

    $importErrors = @()
    try {
        Import-Module -Name (Join-Path $repoRoot 'Scripts\modules\Manager.Commands.psm1') -Force -ErrorAction Stop -ErrorVariable +importErrors
    } catch {
        $importErrors += $_
    }
    if ($importErrors.Count -gt 0) {
        $diagnostics = @($importErrors | ForEach-Object { $_ | Out-String }) -join [Environment]::NewLine
        throw "Manager.Commands import emitted errors:`n$diagnostics"
    }
    if (-not (Get-Command -Name Invoke-ManagerAction -ErrorAction SilentlyContinue)) {
        throw 'Manager.Commands import did not export Invoke-ManagerAction.'
    }

    Write-Output 'PS51_MANAGER_CHAIN_OK'
} catch {
    [Console]::Error.WriteLine($_.Exception.ToString())
    exit 1
}
'@
        $childScript = $childScript.Replace('__REPO_ROOT__', $repoRoot.Replace("'", "''"))
        $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($childScript))
        $output = @(& $windowsPowerShellPath -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -EncodedCommand $encodedCommand 2>&1)

        if ($LASTEXITCODE -ne 0) {
            $diagnostics = ($output | Out-String).Trim()
            throw "Windows PowerShell 5.1 parser/import regression failed (exit $LASTEXITCODE).`n$diagnostics"
        }
        if ((($output | Out-String) -notmatch '(?m)^PS51_MANAGER_CHAIN_OK\s*$')) {
            throw "Windows PowerShell 5.1 parser/import regression did not return its success marker.`n$($output | Out-String)"
        }
    }
}
