# Project-skill discovery namespace backfill.

function Invoke-ProjectSkillBackfill {
    param(
        [string]$AgentsRoot,
        [string]$SkillsDir = ""
    )
    if (-not $SkillsDir) { $SkillsDir = Join-Path $AgentsRoot "skills" }
    $projDir   = Join-Path $AgentsRoot "project_skills"
    if (-not (Test-Path $projDir)) { return }

    New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

    function Get-BackfillLinkTarget {
        param($Item)
        $target = $null
        if ($Item -and ($Item.PSObject.Properties.Name -contains "Target")) {
            $target = $Item.Target
        } elseif ($Item -and ($Item.PSObject.Properties.Name -contains "LinkTarget")) {
            $target = $Item.LinkTarget
        }
        if ($target -is [array]) { $target = $target[0] }
        if ($target) { return [string]$target }
        return ""
    }

    function Test-BackfillPathEquals {
        param(
            [string]$Left,
            [string]$Right
        )
        if (-not $Left -or -not $Right) { return $false }
        try {
            $leftFull = (Resolve-Path -LiteralPath $Left -ErrorAction Stop).Path
        } catch {
            $leftFull = [System.IO.Path]::GetFullPath($Left)
        }
        try {
            $rightFull = (Resolve-Path -LiteralPath $Right -ErrorAction Stop).Path
        } catch {
            $rightFull = [System.IO.Path]::GetFullPath($Right)
        }
        return [string]::Equals($leftFull.TrimEnd('\', '/'), $rightFull.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Get-BackfillFullPath {
        param([string]$Path)
        if (-not $Path) { return "" }
        try {
            return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path.TrimEnd('\', '/')
        } catch {
            return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        }
    }

    function Test-BackfillPathUnderRoot {
        param(
            [string]$Path,
            [string]$Root
        )
        if (-not $Path -or -not $Root) { return $false }
        $full = Get-BackfillFullPath -Path $Path
        $rootFull = Get-BackfillFullPath -Path $Root
        return $full.StartsWith($rootFull + '\', [System.StringComparison]::OrdinalIgnoreCase)
    }

    function Get-BackfillDirectoryHashMap {
        param([string]$Path)
        $root = Get-BackfillFullPath -Path $Path
        $map = @{}
        Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $full = Get-BackfillFullPath -Path $_.FullName
            $relative = $full.Substring($root.Length).TrimStart('\', '/').ToLowerInvariant()
            $map[$relative] = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash
        }
        return $map
    }

    function Test-BackfillDirectoryEquivalent {
        param(
            [string]$Left,
            [string]$Right
        )
        if (-not (Test-Path -LiteralPath $Left) -or -not (Test-Path -LiteralPath $Right)) { return $false }
        $leftMap = Get-BackfillDirectoryHashMap -Path $Left
        $rightMap = Get-BackfillDirectoryHashMap -Path $Right
        if ($leftMap.Count -ne $rightMap.Count) { return $false }
        foreach ($key in $leftMap.Keys) {
            if (-not $rightMap.ContainsKey($key)) { return $false }
            if ($leftMap[$key] -ne $rightMap[$key]) { return $false }
        }
        return $true
    }

    function Test-BackfillDiscoveryStubForTarget {
        param(
            [string]$DiscoveryPath,
            [string]$TargetPath
        )
        if (-not (Test-Path -LiteralPath $DiscoveryPath) -or -not (Test-Path -LiteralPath $TargetPath)) { return $false }

        $files = @(Get-ChildItem -LiteralPath $DiscoveryPath -Recurse -File -Force -ErrorAction SilentlyContinue)
        if ($files.Count -ne 1 -or $files[0].Name -ne "SKILL.md") { return $false }

        $stub = Get-Content -LiteralPath $files[0].FullName -Raw -Encoding UTF8
        $targetFull = (Join-Path (Get-BackfillFullPath -Path $TargetPath) "SKILL.md").Replace('\', '/')
        $agentsRootFull = (Get-BackfillFullPath -Path $AgentsRoot).Replace('\', '/')
        $relativeTarget = $targetFull
        if ($targetFull.StartsWith($agentsRootFull + '/', [System.StringComparison]::OrdinalIgnoreCase)) {
            $relativeTarget = ".agents/" + $targetFull.Substring($agentsRootFull.Length + 1)
        }

        return ($stub -match '(?m)^# Project Route\b') -and
            ($stub -match '(?m)Read and follow the project skill source:') -and
            ($stub -like "*$relativeTarget*")
    }

    function Remove-PhysicalProjectDiscoveryEntry {
        param([string]$Path)
        if (-not (Test-BackfillPathUnderRoot -Path $Path -Root $SkillsDir)) {
            Write-Warn "拒絕移除不在技能 discovery 根目錄內的項目: $Path"
            return $false
        }
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
        return $true
    }

    function Repair-PhysicalProjectSkillDiscoveryEntries {
        $changed = 0
        $blockedLocal = 0
        if (-not (Test-Path -LiteralPath $SkillsDir)) {
            return [PSCustomObject]@{ Changed = $changed; Blocked = $blockedLocal }
        }

        $entries = @(Get-ChildItem -LiteralPath $SkillsDir -Force -ErrorAction SilentlyContinue |
            Where-Object { ($_.Name -match '^project-') -and ($_.Name -ne 'project-context-protocol') })

        foreach ($entry in $entries) {
            $isReparsePoint = [bool]($entry.Attributes -band [IO.FileAttributes]::ReparsePoint)
            if ($isReparsePoint) { continue }

            $skillName = $entry.Name.Substring('project-'.Length)
            $targetPath = Join-Path $projDir $skillName
            $entrySkill = Join-Path $entry.FullName "SKILL.md"

            if (-not $entry.PSIsContainer -or -not (Test-Path -LiteralPath $entrySkill)) {
                Write-Warn "衍生技能 discovery entry 不是有效技能目錄，已保留待手動處理: $($entry.Name)"
                $blockedLocal++
                continue
            }

            if (Test-Path -LiteralPath $targetPath) {
                if ((Test-BackfillDirectoryEquivalent -Left $entry.FullName -Right $targetPath) -or
                    (Test-BackfillDiscoveryStubForTarget -DiscoveryPath $entry.FullName -TargetPath $targetPath)) {
                    if (Remove-PhysicalProjectDiscoveryEntry -Path $entry.FullName) {
                        Write-Ok "重建前已移除重複的實體 discovery 目錄: $($entry.Name)"
                        $changed++
                    } else {
                        $blockedLocal++
                    }
                } else {
                    Write-Warn "衍生技能 discovery entry 與 project_skills 原檔內容不同，已保留避免覆寫: $($entry.Name)"
                    $blockedLocal++
                }
                continue
            }

            if (-not (Test-BackfillPathUnderRoot -Path $entry.FullName -Root $SkillsDir)) {
                Write-Warn "拒絕遷移不在技能 discovery 根目錄內的項目: $($entry.FullName)"
                $blockedLocal++
                continue
            }

            Move-Item -LiteralPath $entry.FullName -Destination $targetPath -ErrorAction Stop
            Write-Ok "已將實體 discovery 技能遷移到 project_skills: $skillName"
            $changed++
        }

        return [PSCustomObject]@{ Changed = $changed; Blocked = $blockedLocal }
    }

    function New-ProjectSkillNamespaceLink {
        param(
            [string]$LinkPath,
            [string]$TargetPath,
            [string]$SkillName
        )

        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath -ErrorAction SilentlyContinue | Out-Null
        if (-not (Test-Path -LiteralPath (Join-Path $LinkPath "SKILL.md"))) {
            New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath -ErrorAction SilentlyContinue | Out-Null
        }

        if (Test-Path -LiteralPath (Join-Path $LinkPath "SKILL.md")) {
            Write-Ok "衍生技能連結已建立: project-$SkillName"
            return $true
        }

        Write-Warn "無法建立連結（需 Developer Mode 或管理員）: project-$SkillName"
        return $false
    }

    $repairResult = Repair-PhysicalProjectSkillDiscoveryEntries
    $count = [int]$repairResult.Changed
    $blocked = [int]$repairResult.Blocked
    $projectSkills = @(Get-ChildItem $projDir -Directory -ErrorAction SilentlyContinue | Where-Object {
        ($_.Name -notmatch '^_') -and (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md"))
    })

    foreach ($skill in $projectSkills) {
        $linkPath = Join-Path $SkillsDir "project-$($skill.Name)"
        $linkItem = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue

        if ($linkItem) {
            $isReparsePoint = [bool]($linkItem.Attributes -band [IO.FileAttributes]::ReparsePoint)
            if (-not $isReparsePoint) {
                Write-Warn "衍生技能 discovery entry 不是符號連結/Junction，已跳過避免覆寫: project-$($skill.Name)"
                $blocked++
                continue
            }

            $target = Get-BackfillLinkTarget -Item $linkItem
            $targetSkill = if ($target) { Join-Path $target "SKILL.md" } else { "" }
            $isValidTarget = (Test-BackfillPathEquals -Left $target -Right $skill.FullName) -and (Test-Path -LiteralPath $targetSkill)
            if ($isValidTarget) {
                continue
            }

            Remove-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
        }

        if (-not (Test-Path -LiteralPath $linkPath)) {
            if (New-ProjectSkillNamespaceLink -LinkPath $linkPath -TargetPath $skill.FullName -SkillName $skill.Name) {
                $count++
            }
        }
    }

    if (($count -eq 0) -and ($blocked -eq 0)) { Write-Step "衍生技能命名空間連結已是最新，無需補建。" }
    if ($blocked -gt 0) { Write-Warn "有 $blocked 個 project-* discovery entry 不是連結，需手動處理。" }
    return $count
}
