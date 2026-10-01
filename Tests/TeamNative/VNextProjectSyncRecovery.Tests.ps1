Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$sourceRepo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path

function Write-RecoveryFixture {
    param([string]$Path, [string]$Content)
    $null = New-Item -ItemType Directory -Path (Split-Path $Path -Parent) -Force
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Get-RecoveryFingerprint {
    param([string]$Root)
    (@(Get-ChildItem -LiteralPath $Root -Recurse -File -Force | ForEach-Object {
        $_.FullName.Substring($Root.Length) + ':' + (Get-FileHash -LiteralPath $_.FullName).Hash
    } | Sort-Object) -join "`n")
}

Describe 'vNext foundation Manager apply recovery and preview' {
    BeforeEach {
        $fixture = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $source = Join-Path $fixture 'source'
        $target = Join-Path $fixture 'project'
        $module = Import-Module (Join-Path $sourceRepo 'Scripts/modules/Manager.ProjectSync.psm1') -Force -PassThru
        Write-RecoveryFixture (Join-Path $source 'Codex/.codex/AGENTS.md') ([IO.File]::ReadAllText((Join-Path $sourceRepo 'Codex/.codex/AGENTS.md')))
        Write-RecoveryFixture (Join-Path $source 'Shared/policies/adapters/codex-subagent-invocation.md') ([IO.File]::ReadAllText((Join-Path $sourceRepo 'Shared/policies/adapters/codex-subagent-invocation.md')))
        Write-RecoveryFixture (Join-Path $source 'Shared/skills/sample/SKILL.md') 'new shared skill'
        Write-RecoveryFixture (Join-Path $source 'Codex/VERSION') 'new-version'
        Write-RecoveryFixture (Join-Path $target '.codex/AGENTS.md') 'old core'
        Write-RecoveryFixture (Join-Path $target '.codex/VERSION') 'old-version'
        Write-RecoveryFixture (Join-Path $target '.agents/memory/user.md') 'memory'
        Write-RecoveryFixture (Join-Path $target '.agents/context/user.md') 'context'
        Write-RecoveryFixture (Join-Path $target '.agents/context/_map/CONTEXT.md') 'existing context index'
        Write-RecoveryFixture (Join-Path $target '.agents/project_skills/_index.md') 'existing project skill index'
        Write-RecoveryFixture (Join-Path $target '.cartridge/index.json') 'local index'
        $arguments = @{
            RepoRoot = $source; Target = $target; ProjectPlatform = 'Codex'
            WriteHeaderAction = {}; AssertSourceSyncedAction = {}
        }
    }
    AfterEach {
        foreach ($record in @($Error)) {
            $message = $record.Exception.Message
            $expected = $message -ceq 'synthetic version write failure'
            $expected = $expected -or (
                $record.FullyQualifiedErrorId -in @('CopyFileInfoItemIOError,Microsoft.PowerShell.Commands.CopyItemCommand', 'System.IO.DirectoryNotFoundException,Microsoft.PowerShell.Commands.CopyItemCommand') -and
                $record.Exception -is [IO.DirectoryNotFoundException] -and $message.Contains((Join-Path $target '.agents/shared'))
            )
            if ($expected) { $Error.Remove($record) }
        }
    }

    It 'uses the existing no-Apply preview without creating or changing any project file' {
        $before = Get-RecoveryFingerprint $target
        $result = Invoke-ManagerProjectRulesSync @arguments
        $result.Succeeded | Should Be $true
        $result.Applied | Should Be $false
        (Get-RecoveryFingerprint $target) | Should Be $before
    }

    It 'restores earlier real copies when a later Shared destination cannot be written' {
        Write-RecoveryFixture (Join-Path $target '.agents/shared') 'user-owned obstruction'
        $before = Get-RecoveryFingerprint $target
        $result = Invoke-ManagerProjectRulesSync @arguments -Apply
        $result.Succeeded | Should Be $false
        $result.RolledBack | Should Be $true
        (Get-RecoveryFingerprint $target) | Should Be $before
        (Test-Path (Join-Path $target '.agents/skills/sample/SKILL.md')) | Should Be $false
    }

    It 'restores the previous version and every copied file when the final marker write fails' {
        Mock -CommandName Set-ManagerProjectVersionFile -ModuleName $module.Name -MockWith {
            [IO.File]::WriteAllText($Path, 'partial version write')
            throw 'synthetic version write failure'
        }
        $before = Get-RecoveryFingerprint $target
        { Invoke-ManagerProjectRulesSync @arguments -Apply } | Should Throw 'synthetic version write failure'
        (Get-RecoveryFingerprint $target) | Should Be $before
    }
}
