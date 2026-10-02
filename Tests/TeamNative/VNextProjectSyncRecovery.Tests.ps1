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
        [IO.Path]::GetRelativePath($Root, $_.FullName) + ':' + (Get-FileHash -LiteralPath $_.FullName).Hash
    } | Sort-Object) -join "`n")
}

function Test-RecoveryExpectedCopyError {
    param([Management.Automation.ErrorRecord]$Record, [string]$TargetRoot)
    $sharedRoot = [IO.Path]::GetFullPath((Join-Path $TargetRoot '.agents/shared')).TrimEnd('\','/') + [IO.Path]::DirectorySeparatorChar
    return (
        $Record.FullyQualifiedErrorId -in @('CopyFileInfoItemIOError,Microsoft.PowerShell.Commands.CopyItemCommand', 'System.IO.DirectoryNotFoundException,Microsoft.PowerShell.Commands.CopyItemCommand') -and
        $Record.Exception -is [IO.DirectoryNotFoundException] -and
        $Record.Exception.Message.Contains($sharedRoot)
    )
}

Describe 'vNext foundation Manager apply recovery and preview' {
    BeforeEach {
        $fixture = [IO.Path]::GetFullPath((Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))))
        $source = Join-Path $fixture 'source'
        $target = Join-Path $fixture 'project'
        $modulePath = [IO.Path]::GetFullPath((Join-Path $sourceRepo 'Scripts/modules/Manager.ProjectSync.psm1'))
        Import-Module $modulePath -Force
        $owners = @(Get-Module -All | Where-Object { $_.Path -eq $modulePath })
        if ($owners.Count -ne 1) { throw "Ambiguous Manager recovery module identity: $modulePath" }
        $module = $owners[0]
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
            $expected = $expected -or (Test-RecoveryExpectedCopyError -Record $record -TargetRoot $target)
            if ($expected) { $Error.Remove($record) }
        }
    }

    It 'matches only the expected copy failure under the same canonical target across an actual short path alias' {
        $longRoot = [IO.Path]::GetFullPath((Split-Path (Get-Module Pester).Path -Parent))
        $fso = New-Object -ComObject Scripting.FileSystemObject
        $shortRoot = $fso.GetFolder($longRoot).ShortPath
        $path = Join-Path $longRoot 'project/.agents/shared/policies/adapters/codex-subagent-invocation.md'
        $message = "Could not find a part of the path '$path'."
        $record = [Management.Automation.ErrorRecord]::new(
            [IO.DirectoryNotFoundException]::new($message),
            'CopyFileInfoItemIOError,Microsoft.PowerShell.Commands.CopyItemCommand',
            [Management.Automation.ErrorCategory]::WriteError, $path)
        (Test-RecoveryExpectedCopyError -Record $record -TargetRoot (Join-Path $shortRoot 'project')) | Should Be $true
        (Test-RecoveryExpectedCopyError -Record $record -TargetRoot (Join-Path $shortRoot 'other-project')) | Should Be $false
        $unexpected = [Management.Automation.ErrorRecord]::new(
            [IO.DirectoryNotFoundException]::new($message), 'UnrelatedCopyFailure',
            [Management.Automation.ErrorCategory]::WriteError, $path)
        (Test-RecoveryExpectedCopyError -Record $unexpected -TargetRoot (Join-Path $shortRoot 'project')) | Should Be $false
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
        # Pester 3 selects ModuleName ambiguously when earlier tests loaded a
        # copied framework. Inject and restore in the exact source instance.
        $original = & $module { (Get-Command Set-ManagerProjectVersionFile).ScriptBlock }
        & $module {
            function script:Set-ManagerProjectVersionFile {
                param([string]$Path,[string]$Version,[switch]$Apply)
                [IO.File]::WriteAllText($Path, 'partial version write')
                throw 'synthetic version write failure'
            }
        }
        $before = Get-RecoveryFingerprint $target
        try {
            { & $module { param($argsMap) Invoke-ManagerProjectRulesSync @argsMap -Apply } $arguments } | Should Throw 'synthetic version write failure'
            (Get-RecoveryFingerprint $target) | Should Be $before
        } finally {
            & $module { param($body) $null=$ExecutionContext.InvokeProvider.Item.Set('Function:\script:Set-ManagerProjectVersionFile',$body,$true,$true) } $original
        }
    }
}

Describe 'Manager project sync result transport' {
    It 'preserves a failed backend aggregate through the actual command facade' {
        $commands = Import-Module (Join-Path $sourceRepo 'Scripts/modules/Manager.Commands.psm1') -Force -PassThru
        $original = & $commands { (Get-Command Invoke-ManagerSyncProjectRules).ScriptBlock }
        try {
            & $commands {
                function script:Invoke-ManagerSyncProjectRules {
                    [pscustomobject]@{ Succeeded=$false; Applied=$true; Platforms=@('Codex'); RequiredStageResults=@([pscustomobject]@{ Stage='required-stage'; Status='Failed' }) }
                }
            }
            $result = & $commands { Invoke-ManagerAction -Action SyncProjectRules -ProjectPlatform Codex -Apply }
            $result.Succeeded | Should Be $false
            $result.RequiredStageResults[0].Status | Should Be 'Failed'
        } finally {
            & $commands { param($body) $null=$ExecutionContext.InvokeProvider.Item.Set('Function:\script:Invoke-ManagerSyncProjectRules',$body,$true,$true) } $original
        }
    }

    It 'emits structured results and accurate exit codes through the real script: <Name>' -TestCases @(
        @{Name='success';Platform='Codex';Apply=$true;Exit=0;Succeeded=$true},
        @{Name='preview';Platform='Codex';Apply=$false;Exit=0;Succeeded=$true},
        @{Name='failure despite success-looking output';Platform='Claude';Apply=$true;Exit=1;Succeeded=$false},
        @{Name='missing result';Platform='Antigravity';Apply=$true;Exit=2;Succeeded=$null}
    ) {
        param($Name,$Platform,$Apply,$Exit,$Succeeded)
        $fixture = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $moduleFixture = @'
function Invoke-ManagerAction {
    param($Action,$ProjectPlatform,[switch]$Apply)
    Write-Host 'sync completed'
    if ($ProjectPlatform -eq 'Antigravity') { return }
    [pscustomobject]@{
        Succeeded=($ProjectPlatform -ne 'Claude'); Applied=[bool]$Apply; Platforms=@($ProjectPlatform)
        RequiredStageResults=@([pscustomobject]@{Stage='required-stage';Required=$true;Status=$(if($ProjectPlatform -eq 'Claude'){'Failed'}else{'Succeeded'});Succeeded=($ProjectPlatform -ne 'Claude')})
    }
}
Export-ModuleMember -Function Invoke-ManagerAction
'@
        Write-RecoveryFixture (Join-Path $fixture 'Scripts/modules/Manager.Commands.psm1') $moduleFixture
        $scriptPath = Join-Path $fixture 'Scripts/AI-RulesManager.ps1'
        Write-RecoveryFixture $scriptPath ([IO.File]::ReadAllText((Join-Path $sourceRepo 'Scripts/AI-RulesManager.ps1')))
        $processArgs = @('-NoProfile','-File',$scriptPath,'-RepoRoot',$fixture,'-Target',$fixture,'-Action','SyncProjectRules','-ProjectPlatform',$Platform)
        if ($Apply) { $processArgs += '-Apply' }
        $output = @(& powershell.exe @processArgs)
        $actualExit = $LASTEXITCODE
        $actualExit | Should Be $Exit
        $frames = @($output | Where-Object { $_ -like 'AI_RULES_MANAGER_RESULT:*' })
        $frames.Count | Should Be 1
        $envelope = $frames[0].Substring('AI_RULES_MANAGER_RESULT:'.Length) | ConvertFrom-Json
        $envelope.Version | Should Be 1
        $envelope.Action | Should Be 'SyncProjectRules'
        if ($null -eq $Succeeded) {
            ($null -eq $envelope.Result) | Should Be $true
        } else {
            $envelope.Result.Succeeded | Should Be $Succeeded
            $envelope.Result.Applied | Should Be $Apply
            $envelope.Result.RequiredStageResults.Count | Should Be 1
        }
    }
}
