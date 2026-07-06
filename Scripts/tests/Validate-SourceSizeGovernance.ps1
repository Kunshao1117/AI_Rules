#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$NoFail,
    [int]$WarningLines = 500,
    [int]$WarningBytes = 30000,
    [int]$RedLines = 1500,
    [int]$RedBytes = 200000
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$script:RepoRootFull = [IO.Path]::GetFullPath($script:RepoRoot).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)

$script:LegacyBaselines = @{}

$script:ScanScopeDescription = @(
    "Second-batch baseline scope: Scripts modules/root/tests including module partials;"
    "Shared policies and policy references;"
    "Shared skill SKILL.md and skill references; named Shared governance matrices/procedures."
    "This is not a repository-wide source size enforcement pass."
) -join " "

$script:ScanTargets = @(
    [PSCustomObject]@{ Label = "Scripts modules"; Root = "Scripts\modules"; Filter = "*.psm1"; Recurse = $false },
    [PSCustomObject]@{ Label = "Scripts module partials"; Root = "Scripts\modules"; Filter = "*.ps1"; Recurse = $true },
    [PSCustomObject]@{ Label = "Scripts root"; Root = "Scripts"; Filter = "*.ps1"; Recurse = $false },
    [PSCustomObject]@{ Label = "Scripts tests"; Root = "Scripts\tests"; Filter = "*.ps1"; Recurse = $false },
    [PSCustomObject]@{ Label = "Shared policies"; Root = "Shared\policies"; Filter = "*.md"; Recurse = $false },
    [PSCustomObject]@{ Label = "Shared policy references"; Root = "Shared\policies\references"; Filter = "*.md"; Recurse = $true },
    [PSCustomObject]@{ Label = "Shared skills"; Root = "Shared\skills"; Filter = "SKILL.md"; Recurse = $true },
    [PSCustomObject]@{ Label = "Shared skill references"; Root = "Shared\skills"; Filter = "*.md"; Recurse = $true; RequiredSegment = "\references\" },
    [PSCustomObject]@{ Label = "Shared workflow capability matrix"; LiteralPath = "Shared\workflow-capability-evidence-matrix.md" },
    [PSCustomObject]@{ Label = "Shared platform capability matrix"; LiteralPath = "Shared\platform-capability-matrix.md" },
    [PSCustomObject]@{ Label = "Shared skill governance"; LiteralPath = "Shared\skill-governance.md" },
    [PSCustomObject]@{ Label = "Shared workflow stage procedures"; LiteralPath = "Shared\workflow-stage-procedures.md" }
)

function Get-RelativeDisplayPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $script:RepoRootFull + [IO.Path]::DirectorySeparatorChar
    if ($full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        return $full.Substring($prefix.Length).Replace('\', '/')
    }

    return $full.Replace('\', '/')
}

function Get-FileLineCount {
    param([Parameter(Mandatory = $true)][string]$Path)

    $count = 0
    $reader = [System.IO.File]::OpenText($Path)
    try {
        while ($true) {
            $line = $reader.ReadLine()
            if ($null -eq $line) {
                break
            }
            $count++
        }
    } finally {
        $reader.Close()
    }

    return $count
}

function Get-EolNormalizedByteCount {
    param([Parameter(Mandatory = $true)][string]$Path)

    $text = [System.IO.File]::ReadAllText($Path)
    $normalized = $text.Replace("`r`n", "`n").Replace("`r", "`n")
    return [int64][System.Text.Encoding]::UTF8.GetByteCount($normalized)
}

function Test-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)][object]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    return $Object.PSObject.Properties.Match($Name).Count -gt 0
}

function Get-GitCommandPath {
    $gitCommand = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($gitCommand) {
        return $gitCommand.Source
    }

    $gitCommand = Get-Command git -ErrorAction SilentlyContinue
    if ($gitCommand) {
        return $gitCommand.Source
    }

    return $null
}

function Get-GitState {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [string]$GitCommand
    )

    if (-not $GitCommand) {
        return "Unknown"
    }

    $trackedPath = & $GitCommand -C $script:RepoRoot ls-files -- $RelativePath
    if ($global:LASTEXITCODE -eq 0 -and $trackedPath) {
        return "Tracked"
    }

    return "New"
}

function Add-ScanFile {
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][System.Collections.Generic.List[object]]$Files,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][hashtable]$Seen,
        [Parameter(Mandatory = $true)][System.IO.FileInfo]$File,
        [Parameter(Mandatory = $true)][string]$Scope
    )

    $relative = Get-RelativeDisplayPath -Path $File.FullName
    if ($Seen.ContainsKey($relative)) {
        return
    }

    $Seen[$relative] = $true
    $Files.Add([PSCustomObject]@{
        Path = $File.FullName
        RelativePath = $relative
        Scope = $Scope
    }) | Out-Null
}

function Get-ScanFiles {
    $seen = @{}
    $files = New-Object System.Collections.Generic.List[object]

    foreach ($target in $script:ScanTargets) {
        if (Test-ObjectProperty -Object $target -Name "LiteralPath") {
            $path = Join-Path $script:RepoRoot $target.LiteralPath
            if (Test-Path -LiteralPath $path -PathType Leaf) {
                Add-ScanFile -Files $files -Seen $seen -File (Get-Item -LiteralPath $path) -Scope $target.Label
            }

            continue
        }

        $root = Join-Path $script:RepoRoot $target.Root
        if (-not (Test-Path -LiteralPath $root -PathType Container)) {
            continue
        }

        $parameters = @{
            LiteralPath = $root
            File = $true
            ErrorAction = "SilentlyContinue"
        }
        if (Test-ObjectProperty -Object $target -Name "Filter") {
            $parameters.Filter = $target.Filter
        }
        if ([bool]$target.Recurse) {
            $parameters.Recurse = $true
        }

        foreach ($file in Get-ChildItem @parameters) {
            if (Test-ObjectProperty -Object $target -Name "RequiredSegment") {
                $relativeForMatch = "\" + (Get-RelativeDisplayPath -Path $file.FullName).Replace("/", "\")
                if ($relativeForMatch.IndexOf($target.RequiredSegment, [StringComparison]::OrdinalIgnoreCase) -lt 0) {
                    continue
                }
            }

            Add-ScanFile -Files $files -Seen $seen -File $file -Scope $target.Label
        }
    }

    return $files.ToArray()
}

function New-SizeFinding {
    param(
        [Parameter(Mandatory = $true)][object]$File,
        [Parameter(Mandatory = $true)][string]$Severity,
        [Parameter(Mandatory = $true)][string]$Reason,
        [Parameter(Mandatory = $true)][int]$Lines,
        [Parameter(Mandatory = $true)][int64]$Bytes,
        [Parameter(Mandatory = $true)][int64]$NormalizedBytes,
        [Parameter(Mandatory = $true)][string]$GitState,
        [string]$Baseline = ""
    )

    return [PSCustomObject]@{
        Path = $File.RelativePath
        Scope = $File.Scope
        Severity = $Severity
        Reason = $Reason
        Lines = $Lines
        Bytes = $Bytes
        NormalizedBytes = $NormalizedBytes
        GitState = $GitState
        Baseline = $Baseline
    }
}

function Get-OversizeFinding {
    param(
        [Parameter(Mandatory = $true)][object]$File,
        [Parameter(Mandatory = $true)][int]$Lines,
        [Parameter(Mandatory = $true)][int64]$Bytes,
        [Parameter(Mandatory = $true)][int64]$NormalizedBytes,
        [Parameter(Mandatory = $true)][string]$GitState
    )

    if ($GitState -eq "Tracked") {
        return New-SizeFinding `
            -File $File `
            -Severity "Yellow" `
            -Reason "ExistingOversizeBaseline" `
            -Lines $Lines `
            -Bytes $Bytes `
            -NormalizedBytes $NormalizedBytes `
            -GitState $GitState
    }

    $reason = "UnassignedOversize"
    if ($GitState -eq "New") {
        $reason = "NewRed"
    }

    return New-SizeFinding `
        -File $File `
        -Severity "Red" `
        -Reason $reason `
        -Lines $Lines `
        -Bytes $Bytes `
        -NormalizedBytes $NormalizedBytes `
        -GitState $GitState
}

function Get-SizeFinding {
    param(
        [Parameter(Mandatory = $true)][object]$File,
        [string]$GitCommand
    )

    $info = Get-Item -LiteralPath $File.Path
    $lineCount = Get-FileLineCount -Path $File.Path
    $byteCount = [int64]$info.Length
    $normalizedByteCount = Get-EolNormalizedByteCount -Path $File.Path
    $gitState = Get-GitState -RelativePath $File.RelativePath -GitCommand $GitCommand
    $isNew = $gitState -eq "New"
    $baselineText = ""

    if ($script:LegacyBaselines.ContainsKey($File.RelativePath)) {
        $baseline = $script:LegacyBaselines[$File.RelativePath]
        $baselineNormalizedBytes = [int64]$baseline.Bytes
        if (Test-ObjectProperty -Object $baseline -Name "NormalizedBytes") {
            $baselineNormalizedBytes = [int64]$baseline.NormalizedBytes
        }

        $baselineText = "$($baseline.Lines) lines / $baselineNormalizedBytes normalized bytes"
        if ($lineCount -le [int]$baseline.Lines -and $normalizedByteCount -le $baselineNormalizedBytes) {
            return New-SizeFinding `
                -File $File `
                -Severity "Yellow" `
                -Reason "LegacyBaseline" `
                -Lines $lineCount `
                -Bytes $byteCount `
                -NormalizedBytes $normalizedByteCount `
                -GitState $gitState `
                -Baseline $baselineText
        }

        return New-SizeFinding `
            -File $File `
            -Severity "Red" `
            -Reason "LegacyBaselineExceeded" `
            -Lines $lineCount `
            -Bytes $byteCount `
            -NormalizedBytes $normalizedByteCount `
            -GitState $gitState `
            -Baseline $baselineText
    }

    if ($lineCount -gt $RedLines -or $byteCount -gt $RedBytes) {
        return Get-OversizeFinding `
            -File $File `
            -Lines $lineCount `
            -Bytes $byteCount `
            -NormalizedBytes $normalizedByteCount `
            -GitState $gitState
    }

    if ($lineCount -gt $WarningLines -or $byteCount -gt $WarningBytes) {
        $reason = "SizeWarning"
        if ($isNew) {
            $reason = "NewSizeWarning"
        }

        return New-SizeFinding `
            -File $File `
            -Severity "Yellow" `
            -Reason $reason `
            -Lines $lineCount `
            -Bytes $byteCount `
            -NormalizedBytes $normalizedByteCount `
            -GitState $gitState
    }

    return New-SizeFinding `
        -File $File `
        -Severity "Green" `
        -Reason "WithinLimit" `
        -Lines $lineCount `
        -Bytes $byteCount `
        -NormalizedBytes $normalizedByteCount `
        -GitState $gitState
}

$git = Get-GitCommandPath
$files = Get-ScanFiles
$results = @(
    foreach ($file in $files) {
        Get-SizeFinding -File $file -GitCommand $git
    }
)

$red = @($results | Where-Object { $_.Severity -eq "Red" })
$yellow = @($results | Where-Object { $_.Severity -eq "Yellow" })
$nonGreen = @($results | Where-Object { $_.Severity -ne "Green" } | Sort-Object Severity, Lines, Path -Descending)

Write-Host "Source size governance scan"
Write-Host "Scope: $script:ScanScopeDescription"
Write-Host "Rules: Yellow over $WarningLines lines or $WarningBytes bytes; Red over $RedLines lines or $RedBytes bytes for new or non-baselined files."
Write-Host "Tracked existing oversize files are Yellow/ExistingOversizeBaseline unless an explicit legacy baseline is exceeded."
Write-Host "Audit.psm1 is expected to remain a thin facade; Audit/*.ps1 partials are scanned as internal module source."
Write-Host "Scanned files: $($results.Count)"
Write-Host "Yellow findings: $($yellow.Count)"
Write-Host "Red findings: $($red.Count)"

if ($nonGreen.Count -gt 0) {
    Write-Host ""
    $nonGreen |
        Select-Object Path, Severity, Reason, Lines, Bytes, NormalizedBytes, GitState, Baseline |
        Format-Table -AutoSize
}

if ($red.Count -gt 0) {
    Write-Host ""
    if ($NoFail) {
        Write-Host "[WARN] Red source size findings were reported, but -NoFail is active."
        exit 0
    }

    Write-Host "[FAIL] Red source size findings require split ownership, baseline assignment, or a tighter threshold decision."
    exit 1
}

Write-Host ""
Write-Host "[PASS] No blocking source size governance findings."
exit 0
