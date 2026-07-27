Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Import-Module (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1') -Force
$script:codexModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Codex.psm1') -Force -PassThru
$script:claudeModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Claude.psm1') -Force -PassThru
$script:antigravityModule = Import-Module (Join-Path $repoRoot 'Scripts\modules\Platform-Antigravity.psm1') -Force -PassThru

function Get-RetiredReflectionSkillBytes {
    param([string]$RelativePath)

    # The artifact is intentionally absent from the current source. Locate its
    # last tracked version so this test can exercise official predecessor bytes
    # without retaining a second live copy in the framework.
    $history = @(& git -C $repoRoot log --format=%H --all -- "Shared/skills/$RelativePath")
    foreach ($commit in $history) {
        $revision = "$commit`:Shared/skills/$RelativePath"
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = 'git'
        $startInfo.Arguments = "cat-file blob $revision"
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.WorkingDirectory = $repoRoot
        $process = [System.Diagnostics.Process]::Start($startInfo)
        $memory = New-Object System.IO.MemoryStream
        try {
            $process.StandardOutput.BaseStream.CopyTo($memory)
            $process.WaitForExit()
            if ($process.ExitCode -eq 0) {
                return ,([byte[]]$memory.ToArray())
            }
        } finally {
            $memory.Dispose()
            $process.Dispose()
        }
    }

    throw "The historical official Reflection Skill is unavailable: $RelativePath"
}

function Add-RetiredReflectionSkills {
    param(
        [string]$SkillsRoot,
        [switch]$ModifyCodingSkill
    )

    foreach ($relativePath in @('coding-reflection-gate/SKILL.md', 'design-reflection-gate/SKILL.md')) {
        $targetPath = Join-Path $SkillsRoot ($relativePath -replace '/', '\\')
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllBytes($targetPath, (Get-RetiredReflectionSkillBytes -RelativePath $relativePath))
    }

    if ($ModifyCodingSkill) {
        $path = Join-Path $SkillsRoot 'coding-reflection-gate\SKILL.md'
        [System.IO.File]::AppendAllText($path, "`n# user change", [System.Text.UTF8Encoding]::new($false))
    }
}

function Get-TreeFingerprint {
    param([string]$Root)

    $records = @(
        Get-ChildItem -LiteralPath $Root -Force -Recurse | Sort-Object FullName | ForEach-Object {
            $relative = $_.FullName.Substring($Root.Length).TrimStart('\', '/') -replace '\\', '/'
            if ($_.PSIsContainer) { "D|$relative" }
            else { "F|$relative|$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)" }
        }
    )
    $bytes = [System.Text.Encoding]::UTF8.GetBytes(($records -join "`n"))
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($algorithm.ComputeHash($bytes))).Replace('-', '')
    } finally {
        $algorithm.Dispose()
    }
}

function Invoke-PlatformFresh {
    param([object]$Platform, [string]$Target)

    & $Platform.Module {
        param($Name, $FrameworkRoot, $TargetRoot, $SharedSkillsRoot)
        switch ($Name) {
            'Codex' { Invoke-CodexFresh -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
            'Claude' { Invoke-ClaudeFresh -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
            'Antigravity' { Invoke-AgFresh -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
        }
    } $Platform.Name $Platform.FrameworkRoot $Target (Join-Path $repoRoot 'Shared\skills')
}

function Invoke-PlatformUpgrade {
    param([object]$Platform, [string]$Target)

    & $Platform.Module {
        param($Name, $FrameworkRoot, $TargetRoot, $SharedSkillsRoot)
        switch ($Name) {
            'Codex' { Invoke-CodexUpgrade -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
            'Claude' { Invoke-ClaudeUpgrade -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
            'Antigravity' { Invoke-AgUpgrade -FrameworkRoot $FrameworkRoot -Target $TargetRoot -SharedSkillsRoot $SharedSkillsRoot }
        }
    } $Platform.Name $Platform.FrameworkRoot $Target (Join-Path $repoRoot 'Shared\skills')
}

Describe 'Retired Reflection Skill deployment migration' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ai-rules-retired-reflection-' + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
        $script:platforms = @(
            [PSCustomObject]@{ Name = 'Codex'; Module = $script:codexModule; FrameworkRoot = Join-Path $repoRoot 'Codex'; SkillsRelativePath = '.agents\skills' },
            [PSCustomObject]@{ Name = 'Claude'; Module = $script:claudeModule; FrameworkRoot = Join-Path $repoRoot 'Claude'; SkillsRelativePath = '.claude\skills' },
            [PSCustomObject]@{ Name = 'Antigravity'; Module = $script:antigravityModule; FrameworkRoot = Join-Path $repoRoot 'Antigravity'; SkillsRelativePath = '.agents\skills' }
        )
        foreach ($platform in $script:platforms) {
            & $platform.Module {
                Set-Item -Path Function:Invoke-ConfirmGate -Value { return $true }
            }
        }
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
    }

    It 'does not deploy either retired Reflection Skill during Fresh installation' {
        foreach ($platform in $script:platforms) {
            $target = Join-Path $script:tempRoot $platform.Name
            Invoke-PlatformFresh -Platform $platform -Target $target
            $skillsRoot = Join-Path $target $platform.SkillsRelativePath
            foreach ($relativePath in @('coding-reflection-gate\SKILL.md', 'design-reflection-gate\SKILL.md')) {
                if (Test-Path -LiteralPath (Join-Path $skillsRoot $relativePath)) {
                    throw "$($platform.Name) Fresh deployed a retired Reflection Skill: $relativePath"
                }
            }
        }
    }

    It 'removes only the official retired skills on every platform Upgrade and is idempotent' {
        foreach ($platform in $script:platforms) {
            $target = Join-Path $script:tempRoot $platform.Name
            Invoke-PlatformFresh -Platform $platform -Target $target
            $skillsRoot = Join-Path $target $platform.SkillsRelativePath
            Add-RetiredReflectionSkills -SkillsRoot $skillsRoot

            Invoke-PlatformUpgrade -Platform $platform -Target $target
            foreach ($relativePath in @('coding-reflection-gate\SKILL.md', 'design-reflection-gate\SKILL.md')) {
                if (Test-Path -LiteralPath (Join-Path $skillsRoot $relativePath)) {
                    throw "$($platform.Name) Upgrade retained an official retired skill: $relativePath"
                }
            }
            foreach ($directory in @('coding-reflection-gate', 'design-reflection-gate')) {
                if (Test-Path -LiteralPath (Join-Path $skillsRoot $directory)) {
                    throw "$($platform.Name) Upgrade retained an empty retired skill directory: $directory"
                }
            }

            $firstFingerprint = Get-TreeFingerprint -Root $target
            Invoke-PlatformUpgrade -Platform $platform -Target $target
            $secondFingerprint = Get-TreeFingerprint -Root $target
            if ($firstFingerprint -ne $secondFingerprint) {
                throw "$($platform.Name) repeated Upgrade changed the already-migrated target."
            }
        }
    }

    It 'preserves modified retired skills with an explicit warning and leaves user skills untouched' {
        $skillsRoot = Join-Path $script:tempRoot '.agents\skills'
        Add-RetiredReflectionSkills -SkillsRoot $skillsRoot -ModifyCodingSkill
        $userSkillPath = Join-Path $skillsRoot 'user-owned-skill\SKILL.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $userSkillPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($userSkillPath, "---`nname: user-owned-skill`n---`n", [System.Text.UTF8Encoding]::new($false))
        $userHash = (Get-FileHash -LiteralPath $userSkillPath -Algorithm SHA256).Hash

        $output = @(Sync-SharedSkills -SharedSkillsRoot (Join-Path $repoRoot 'Shared\skills') -TargetSkillsPath $skillsRoot -Mode Diff 6>&1)
        if (-not (Test-Path -LiteralPath (Join-Path $skillsRoot 'coding-reflection-gate\SKILL.md'))) {
            throw 'A modified retired Reflection Skill was deleted.'
        }
        if (Test-Path -LiteralPath (Join-Path $skillsRoot 'design-reflection-gate\SKILL.md')) {
            throw 'An official retired Reflection Skill was not deleted.'
        }
        if ((Get-FileHash -LiteralPath $userSkillPath -Algorithm SHA256).Hash -ne $userHash) {
            throw 'An unrelated user Skill was changed or removed.'
        }
        if (($output | Out-String) -notmatch 'preserved_user_modified_retired_skill: coding-reflection-gate/SKILL.md') {
            throw 'Preserving a modified retired skill did not emit the required explicit warning.'
        }
    }

    It 'leaves no formal Reflection references in indexes, workflow or policy owners, or runtime copies' {
        $runtimeRoot = Join-Path $script:tempRoot 'runtime'
        $runtimeAgentsRoot = Join-Path $runtimeRoot '.agents'
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $repoRoot 'Shared\skills') -TargetSkillsPath (Join-Path $runtimeAgentsRoot 'skills') -Mode Full
        $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $repoRoot 'Shared') -TargetAgentsRoot $runtimeAgentsRoot -Mode Full
        $paths = @(
            @{ Root = $repoRoot; RelativePath = 'Shared\skills\_index.md' },
            @{ Root = $repoRoot; RelativePath = 'Shared\policies\workflow-orchestration.md' },
            @{ Root = $repoRoot; RelativePath = 'Shared\policies\team-native-core.md' },
            @{ Root = $runtimeRoot; RelativePath = '.agents\skills\_index.md' },
            @{ Root = $runtimeRoot; RelativePath = '.agents\shared\policies\workflow-orchestration.md' },
            @{ Root = $runtimeRoot; RelativePath = '.agents\shared\policies\team-native-core.md' }
        )
        foreach ($entry in $paths) {
            $path = Join-Path $entry.Root $entry.RelativePath
            $content = Get-Content -LiteralPath $path -Raw -Encoding UTF8
            if ($content -match 'coding-reflection-gate|design-reflection-gate') {
                throw "Formal Reflection reference remained after retirement: $($entry.RelativePath)"
            }
        }
    }
}
