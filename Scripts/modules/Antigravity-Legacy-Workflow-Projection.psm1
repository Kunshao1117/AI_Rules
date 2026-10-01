# Date-gated legacy Antigravity Workflow projection; no runtime retirement.

function Get-AntigravityLegacyWorkflowProjection {
    param(
        [Parameter(Mandatory = $true)][string]$ManifestPath,
        [Parameter(Mandatory = $true)][string]$SourceWorkflowsRoot,
        [datetime]$AsOf = (Get-Date)
    )
    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf) -or
        -not (Test-Path -LiteralPath $SourceWorkflowsRoot -PathType Container)) {
        throw 'Antigravity legacy Workflow manifest or source is missing.'
    }
    $manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $retireOn = [datetime]::ParseExact([string]$manifest.retire_on, 'yyyy-MM-dd',
        [Globalization.CultureInfo]::InvariantCulture)
    $expected = @($manifest.source_files | Sort-Object)
    $actual = @(Get-ChildItem -LiteralPath $SourceWorkflowsRoot -File -Filter '*.md' |
        ForEach-Object { $_.Name } | Sort-Object)
    if ($expected.Count -ne 18 -or ($expected -join '|') -cne ($actual -join '|')) {
        throw 'Antigravity legacy Workflow manifest does not exactly cover its source files.'
    }
    return [PSCustomObject]@{
        Project = $AsOf.Date -lt $retireOn.Date
        RetireOn = $retireOn
        SourceFiles = $expected
        CommandCount = @($expected | Where-Object { $_ -notlike '_*' }).Count
    }
}

Export-ModuleMember -Function Get-AntigravityLegacyWorkflowProjection
