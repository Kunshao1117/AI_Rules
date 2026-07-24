Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$windowsPowerShellPath = if ($env:WINDIR) {
    Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
} else {
    $null
}
$windowsPowerShellAvailable = $null -ne $windowsPowerShellPath -and (Test-Path -LiteralPath $windowsPowerShellPath -PathType Leaf)

Describe 'Windows PowerShell 5.1 manager parser compatibility' {
    It 'parses the manager entry chain and imports it without invoking SyncProjectRules' -Skip:(-not $windowsPowerShellAvailable) {
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
        'Scripts\modules\Manager.Config.psm1',
        'Scripts\modules\Core.Reporting.psm1',
        'Scripts\modules\Core.Upgrade.psm1',
        'Scripts\modules\Core.Infrastructure.psm1',
        'Scripts\modules\Core.Cleanup.psm1',
        'Scripts\modules\Core.Gitignore.psm1'
    )

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
