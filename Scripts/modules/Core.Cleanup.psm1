# Safe cleanup of orphaned framework files.

Import-Module -Name (Join-Path $PSScriptRoot 'Core.Reporting.psm1') -Force

function Remove-OrphanFiles {
    param(
        [array]$Report,
        [string]$TargetRoot,
        [string[]]$ProtectedDirs = @()
    )
    $orphans = $Report | Where-Object { $_.Status -eq "ORPHAN" }
    if (-not $orphans -or @($orphans).Count -eq 0) { return }

    $resolvedTargetRoot = (Resolve-Path -LiteralPath $TargetRoot).Path
    $protectedRoots = @()
    foreach ($dir in $ProtectedDirs) {
        $candidate = Join-Path $resolvedTargetRoot $dir
        if (Test-Path -LiteralPath $candidate) {
            $protectedRoots += (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    function Test-IsUnderRoot {
        param(
            [string]$Path,
            [string]$Root
        )
        $fullPath = [System.IO.Path]::GetFullPath($Path)
        $fullRoot = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
        return $fullPath.Equals($fullRoot, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith($fullRoot + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or
            $fullPath.StartsWith($fullRoot + [System.IO.Path]::AltDirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Test-IsProtectedPath {
        param([string]$Path)
        foreach ($root in $protectedRoots) {
            if (Test-IsUnderRoot -Path $Path -Root $root) { return $true }
        }
        return $false
    }

    Write-Step "正在清除 $(@($orphans).Count) 個孤兒檔案..."
    foreach ($item in $orphans) {
        $path = [System.IO.Path]::GetFullPath((Join-Path $resolvedTargetRoot $item.Path))
        if (-not (Test-IsUnderRoot -Path $path -Root $resolvedTargetRoot)) {
            Write-Warn "略過超出目標根目錄的孤兒路徑: $($item.Path)"
            continue
        }
        if (Test-IsProtectedPath -Path $path) {
            Write-Warn "略過受保護目錄內的孤兒路徑: $($item.Path)"
            continue
        }
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
            Write-Ok "已刪除孤兒: $($item.Path)"
        }
    }
    Get-ChildItem -LiteralPath $resolvedTargetRoot -Directory -Recurse |
        Sort-Object { $_.FullName.Length } -Descending |
        ForEach-Object {
            if ((-not (Test-IsProtectedPath -Path $_.FullName)) -and
                (@(Get-ChildItem -LiteralPath $_.FullName -Force).Count -eq 0)) {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
            }
        }
    Write-Ok "孤兒清除完成。"
}
