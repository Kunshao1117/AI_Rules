$modulePath = Join-Path $PSScriptRoot '..\..\Scripts\modules\Core.ProjectSkills.psm1'
$expectedMessage = '衍生技能命名空間連結已是最新，無需補建。'

Describe 'Core.ProjectSkills Windows PowerShell 5.1 encoding' {
    It 'has a UTF-8 BOM and renders the zero-change project skill links message without mojibake' {
        $bytes = [System.IO.File]::ReadAllBytes($modulePath)
        $hasUtf8Bom = $bytes.Length -ge 3 -and
            $bytes[0] -eq 0xEF -and
            $bytes[1] -eq 0xBB -and
            $bytes[2] -eq 0xBF
        $hasUtf8Bom | Should Be $true

        $powershellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        (Test-Path -LiteralPath $powershellExe) | Should Be $true

        $fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ps51-project-skills-encoding-' + [Guid]::NewGuid().ToString('N'))
        $agentsRoot = Join-Path $fixtureRoot '.agents'
        $skillsDir = Join-Path $agentsRoot 'skills'
        $runnerPath = Join-Path $fixtureRoot 'invoke-project-skill-links.ps1'

        try {
            New-Item -ItemType Directory -Path (Join-Path $agentsRoot 'project_skills'), $skillsDir -Force | Out-Null
            $runner = @'
$ErrorActionPreference = 'Stop'
Import-Module -Name $args[0] -Force
Invoke-ProjectSkillBackfill -AgentsRoot $args[1] -SkillsDir $args[2]
'@
            [System.IO.File]::WriteAllText($runnerPath, $runner, (New-Object System.Text.UTF8Encoding($true)))

            $output = & $powershellExe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $runnerPath $modulePath $agentsRoot $skillsDir 2>&1
            $exitCode = $LASTEXITCODE
            $text = $output | Out-String

            $exitCode | Should Be 0
            $text | Should Match ([regex]::Escape($expectedMessage))
            $text | Should Not Match '[ÃÂÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ]'
            $text | Should Not Match 'Invoke-ProjectSkillBackfill|Write-Step|Core\.ProjectSkills\.psm1|(?m)^\s*function\s+'
        }
        finally {
            if (Test-Path -LiteralPath $fixtureRoot) {
                Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
            }
        }
    }
}
