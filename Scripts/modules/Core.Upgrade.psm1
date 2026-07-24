# Upgrade scan and apply lifecycle functions.

function Get-UpgradeReport {
    param(
        [string]$SourceRoot,
        [string]$TargetRoot,
        [string[]]$ScanDirs       = @("rules", "workflows"),
        [string[]]$ProtectedDirs  = @("memory", "project_skills", "context"),
        [string[]]$ExcludeFiles   = @(),
        [string[]]$ScanFiles      = @(),
        [switch]$PreserveProjectIdentity
    )

    $results = @()

    foreach ($file in $ScanFiles) {
        $srcFile = Join-Path $SourceRoot $file
        if (-Not (Test-Path -LiteralPath $srcFile)) { continue }
        if ((Split-Path $file -Leaf) -in $ExcludeFiles) { continue }
        $rel = $file.Replace("\", "/")
        $tgtFile = Join-Path $TargetRoot $file
        $results += Compare-FrameworkFile -SourcePath $srcFile -TargetPath $tgtFile -RelativePath $rel -IgnoreProjectIdentity:$PreserveProjectIdentity
    }

    foreach ($dir in $ScanDirs) {
        $srcPath = Join-Path $SourceRoot $dir
        if (-Not (Test-Path $srcPath)) { continue }

        Get-ChildItem $srcPath -File -Recurse | ForEach-Object {
            if ($_.Name -in $ExcludeFiles) { return }
            $rel     = $_.FullName.Substring($SourceRoot.Length).TrimStart('\', '/').Replace("\", "/")
            $tgtFile = Join-Path $TargetRoot $rel
            $results += Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel -IgnoreProjectIdentity:$PreserveProjectIdentity
        }
    }

    foreach ($file in $ScanFiles) {
        if ((Split-Path $file -Leaf) -in $ExcludeFiles) { continue }
        $tgtFile = Join-Path $TargetRoot $file
        if (-Not (Test-Path -LiteralPath $tgtFile)) { continue }
        $srcFile = Join-Path $SourceRoot $file
        if (-Not (Test-Path -LiteralPath $srcFile)) {
            $results += [PSCustomObject]@{ Status = "ORPHAN"; Path = $file.Replace("\", "/") }
        }
    }

    foreach ($dir in $ScanDirs) {
        $tgtPath = Join-Path $TargetRoot $dir
        if (-Not (Test-Path $tgtPath)) { continue }

        Get-ChildItem $tgtPath -File -Recurse | ForEach-Object {
            $rel     = $_.FullName.Substring($TargetRoot.Length).TrimStart('\', '/').Replace("\", "/")
            if ($_.Name -in $ExcludeFiles) { return }
            $srcFile = Join-Path $SourceRoot $rel
            if (-Not (Test-Path $srcFile)) {
                $results += [PSCustomObject]@{ Status = "ORPHAN"; Path = $rel }
            }
        }
    }

    foreach ($protDir in $ProtectedDirs) {
        $tgtProt = Join-Path $TargetRoot $protDir
        if (-Not (Test-Path $tgtProt)) { continue }
        Get-ChildItem $tgtProt -Directory -Recurse | Where-Object {
            (Test-Path (Join-Path $_.FullName "SKILL.md")) -or
            (Test-Path (Join-Path $_.FullName "MEMORY.md")) -or
            (Test-Path (Join-Path $_.FullName "CONTEXT.md"))
        } | ForEach-Object {
            $rel = $_.FullName.Substring($tgtProt.Length).TrimStart('\', '/').Replace("\", "/")
            $results += [PSCustomObject]@{ Status = "KEEP"; Path = "$protDir/$rel/" }
        }
    }

    return $results
}

function Install-Upgrade {
    param(
        [array]$Report,
        [string]$SourceRoot,
        [string]$TargetRoot,
        [switch]$PreserveProjectIdentity
    )
    $applied = 0
    foreach ($item in $Report) {
        if ($item.Status -notin @("NEW", "CHANGED")) { continue }
        $srcFile = Join-Path $SourceRoot $item.Path
        $tgtFile = Join-Path $TargetRoot $item.Path
        $tgtDir  = Split-Path $tgtFile -Parent
        $projectIdentity = $null
        if ($PreserveProjectIdentity -and (Test-Path -LiteralPath $tgtFile)) {
            $projectIdentity = Get-ProjectIdentityBlock -Text (Get-Content -LiteralPath $tgtFile -Raw -Encoding UTF8)
        }
        if (-Not (Test-Path $tgtDir)) { New-Item -ItemType Directory $tgtDir -Force | Out-Null }
        Copy-Item $srcFile $tgtFile -Force
        if ($projectIdentity) {
            $null = Restore-ProjectIdentityBlock -Path $tgtFile -ProjectIdentityBlock $projectIdentity
        }
        $verb = if ($item.Status -eq "NEW") { "已建立" } else { "已更新" }
        Write-Ok "\${verb}: $($item.Path)"
        $applied++
    }
    return $applied
}

function Invoke-ConfirmGate {
    param([string]$Message = "是否繼續？(Y/N)")
    $answer = Read-Host "  $Message"
    return ($answer -match "^[Yy]$")
}

function Get-ReleaseNotes {
    param(
        [string]$ChangelogPath
    )
    if (-Not (Test-Path $ChangelogPath)) { return @() }
    $lines     = Get-Content $ChangelogPath
    $capturing = $false
    $notes     = @()
    foreach ($line in $lines) {
        if ($line -match "^## ") {
            if ($capturing) { break }
            $capturing = $true
            continue
        }
        if ($capturing) { $notes += $line }
    }
    return $notes
}
