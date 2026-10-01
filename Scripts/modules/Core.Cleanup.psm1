# Orphan inventory is not proof of framework ownership.
# Owner: Shared/policies/references/source-runtime-surface-map.md
Import-Module -Name (Join-Path $PSScriptRoot 'Core.Reporting.psm1') -Force

function Remove-OrphanFiles {
    param(
        [array]$Report,
        [string]$TargetRoot,
        [string[]]$ProtectedDirs = @()
    )
    # Preserve the call contract; retirement belongs to historical hash allowlists.
    # Never sweep unknown files or empty directories.
    foreach ($item in @($Report | Where-Object { $_.Status -eq 'ORPHAN' })) {
        Write-Warn "preserved_unknown_ownership: $($item.Path); source absence is not retirement authority; manual resolution required."
    }
}
