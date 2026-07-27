Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Write-ClaudeSyncFixtureFile {
    param([string]$Path, [string]$Content)

    $parent = Split-Path $Path -Parent
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
}

Describe 'Claude public Deploy Sync entry' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ai-rules-claude-sync-entry-' + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
        $script:targetRoot = Join-Path $script:tempRoot 'project'
        $sourceCore = Get-Content -LiteralPath (Join-Path $repoRoot 'Claude\.claude\rules\core-identity.md') -Raw -Encoding UTF8
        Write-ClaudeSyncFixtureFile -Path (Join-Path $script:targetRoot '.claude\rules\core-identity.md') -Content $sourceCore
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
    }

    It 'loads modules and synchronizes skills and governance references from the normal Deploy wrapper without error records' {
        $runnerPath = Join-Path $script:tempRoot 'run-claude-sync.ps1'
        $runner = @'
param([string]$DeployScript, [string]$Target)
$ErrorActionPreference = 'Stop'
$Error.Clear()
try {
    & $DeployScript -Platform Claude -Mode Sync -Target $Target
    if ($Error.Count -ne 0) { throw "Deploy Sync completed with $($Error.Count) PowerShell error record(s)." }
    [PSCustomObject]@{ Succeeded = $true; ErrorCount = $Error.Count } | ConvertTo-Json -Compress
    exit 0
} catch {
    [PSCustomObject]@{
        Succeeded = $false
        ErrorId = $_.FullyQualifiedErrorId
        Message = $_.Exception.Message
        ErrorCount = $Error.Count
    } | ConvertTo-Json -Compress
    exit 1
}
'@
        Write-ClaudeSyncFixtureFile -Path $runnerPath -Content $runner

        $powershellPath = (Get-Command -Name powershell.exe -CommandType Application -ErrorAction Stop | Select-Object -First 1).Path
        $output = @(& $powershellPath -NoProfile -ExecutionPolicy Bypass -File $runnerPath `
            -DeployScript (Join-Path $repoRoot 'Scripts\Deploy.ps1') `
            -Target $script:targetRoot 2>&1)
        $exitCode = $LASTEXITCODE
        $json = [string](@($output | ForEach-Object { [string]$_ } | Where-Object { $_.TrimStart().StartsWith('{') } | Select-Object -Last 1))
        if ([string]::IsNullOrWhiteSpace($json)) {
            throw "Claude Deploy Sync returned no result (exit $exitCode): $($output | Out-String)"
        }
        $result = $json | ConvertFrom-Json -ErrorAction Stop
        if ($exitCode -ne 0 -or -not $result.Succeeded -or $result.ErrorCount -ne 0) {
            throw "Claude Deploy Sync failed: $($output | Out-String)"
        }

        $pairs = @(
            @{ Source = 'Shared\skills\programming-team-governance\SKILL.md'; Target = '.claude\skills\programming-team-governance\SKILL.md' },
            @{ Source = 'Shared\policies\team-native-core.md'; Target = '.agents\shared\policies\team-native-core.md' }
        )
        foreach ($pair in $pairs) {
            $sourcePath = Join-Path $repoRoot $pair.Source
            $targetPath = Join-Path $script:targetRoot $pair.Target
            if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
                throw "Claude Deploy Sync did not create: $($pair.Target)"
            }
            if ((Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash) {
                throw "Claude Deploy Sync source/runtime parity failed: $($pair.Target)"
            }
        }
    }
}
