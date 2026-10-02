#Requires -Version 5.1

Import-Module (Join-Path $PSScriptRoot "Manager.Deployment.psm1") -Force

function Invoke-ManagerAction {
    param(
        [ValidateSet("Check", "Plan", "Apply", "SyncGlobal", "SyncProjectRules", "CleanupOrphans", "Gitignore", "MemoryMigration")]
        [string]$Action,

        [string]$RepoRoot,

        [string]$Target,

        [string]$ProfileRoot,

        [switch]$Apply,

        [switch]$RemoveOrphans,

        [ValidateSet("Auto", "Codex", "Claude", "Antigravity")]
        [string]$ProjectPlatform,

        [ValidateSet("Append", "CleanSimilar", "Overwrite")]
        [string]$GitignoreMode,

        [switch]$WhatIf,

        [switch]$ManagedSource
    )

    switch ($Action) {
        "Check"            { Invoke-ManagerCheck -RepoRoot $RepoRoot -ManagedSource:$ManagedSource }
        "Plan"             { Invoke-ManagerPlan -RepoRoot $RepoRoot -ManagedSource:$ManagedSource }
        "Apply"            { Invoke-ManagerApplyUpdate -RepoRoot $RepoRoot -Apply:$Apply -ManagedSource:$ManagedSource -WhatIf:$WhatIf }
        "SyncGlobal"       { Invoke-ManagerSyncGlobal -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -Apply:$Apply }
        "SyncProjectRules" { Invoke-ManagerSyncProjectRules -RepoRoot $RepoRoot -Target $Target -ProjectPlatform $ProjectPlatform -Apply:$Apply -ManagedSource:$ManagedSource }
        "CleanupOrphans"   { Invoke-ManagerCleanupOrphans -RepoRoot $RepoRoot -Target $Target -Apply:$Apply -RemoveOrphans:$RemoveOrphans }
        "Gitignore"        { Invoke-ManagerGitignoreMaintenance -Target $Target -GitignoreMode $GitignoreMode -Apply:$Apply }
        "MemoryMigration"  { Invoke-ManagerMemoryMigration -Target $Target -Apply:$Apply -WhatIf:$WhatIf }
    }
}

Export-ModuleMember -Function Invoke-ManagerAction
