---
name: skill-factory
description: >
  Skill generation SOP for creating shared framework skills, project-derived skills,
  and user Codex skills. Enforces Codex SKILL.md compatibility, AI_Rules layer
  placement, Director review gate, and project_skills/ isolation.
  Use when: 需要建立新的專案衍生技能、從健檢建議萃取技能、
  建立 Shared skill、建立 Codex skill、或任何涉及 技能產生/自動繁衍/
  建立新技能/create skill/update skill 的場景。
  DO NOT use when: 只是更新既有 Shared skill 的觸發描述或文件，不需要建立
  新技能；或只是討論技能想法、不準備寫入。
metadata:
  author: antigravity
  version: "5.1"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:write"]
---

# Skill Factory — Skill Generation Protocol

## 1. Trigger Conditions (觸發條件)

```
Trigger?
├── Director explicitly instructs skill creation → Proceed
├── /08_audit Phase G detects recurring patterns across 3+ modules → Proceed
├── /04_fix or /07_debug identifies reusable methodology → Proceed
└── None of above → Do NOT invoke this skill
```

## 2. Pre-Generation Checklist

- [ ] Target layer is classified: shared framework, project-derived, or user Codex
- [ ] No existing framework skill covers this functionality
- [ ] No existing project skill covers this functionality
- [ ] Pattern is genuinely reusable (applies to 2+ future scenarios)
- [ ] Skill name follows kebab-case convention (1-64 characters)

## 3. Generation Procedure

### Step 0: Layer Selection

```
[LAYER GATE] Determine target layer before writing:
├── Cross-project framework behavior AND current workspace is the AI_Rules framework source repository? → Shared framework skill
│   ├── Source path: Shared/skills/{skill-name}/SKILL.md
│   ├── Register: Shared/skills/_index.md
│   └── Sync target: platform skills directories through the deployment sync path
├── Cross-project framework behavior in a downstream project without framework source root? → stop and ask the Director to run from AI_Rules source or explicitly downgrade the target to project-derived scope
├── Single project repeatable behavior? → Project-derived skill
│   ├── Source path: .agents/project_skills/{project-code}-{skill-name}/SKILL.md
│   ├── Register: .agents/project_skills/_index.md
│   └── Discovery link: .agents/skills/project-{skill-name}
├── Personal/global Codex behavior? → User Codex skill
│   ├── Source path: user's Codex skills directory
│   └── Register: no AI_Rules project index unless Director explicitly asks
└── Lifecycle entry or command routing? → Workflow/command entry, not an operational skill
```

Do not create Shared framework skills from a downstream project unless the Director has provided and approved the AI_Rules framework source root.
Do not route Shared framework skills through `.agents/project_skills/`.
Do not add project prefixes to Shared framework skill names.

### Step 1: Name & Scope Definition

1. Choose a descriptive ASCII kebab-case name (lowercase letters, digits, and hyphens only; 1-64 characters).
2. For new Codex-compatible skills, the directory name and frontmatter `name` MUST match.
3. Put localized names, legacy aliases, and explicit trigger phrases in `description`, not in `name`.
2. **Project skills MUST use a project-code prefix** to prevent collision with future framework skills:
   - Format: `{project-code}-{skill-name}` (e.g., `bartendermap-booking-rules`, `myapp-auth-patterns`)
   - Project code: short 2–12 char identifier matching the project (e.g., `bartendermap`, `myapp`)
   - Framework core skills NEVER use a hyphenated project-code prefix — collision is impossible by design
4. Define scope — what it covers and what it does NOT cover

### Step 1.5: Style Determination (風格判定)

```
[STYLE GATE] Determine instruction style for the new skill:
├── Consequence severity: wrong judgment → security breach / data corruption / memory pollution?
│   └── YES → 🔴 Imperative
├── Deterministic output: must produce precise PASS/FAIL?
│   └── YES → 🔴 Imperative
├── Cross-module consistency: must execute identically across all modules?
│   └── YES → 🔴 Imperative
├── Flow control node: sits at workflow decision point, result affects branching?
│   └── YES → 🟡 Hybrid (gate at decision node + guided procedure)
└── None of above → 🟢 Guided
```

Record the result in `metadata.style` field.

### Step 2: Write SKILL.md

1. Read references/skill-template.md → 取得標準模板
2. Read references/skill-style-guide.md → 取得書寫風格規範（含 §6 風格密度對照表）
3. Top-level frontmatter MUST stay Codex-compatible: only `name`, `description`, optional `license`, optional `allowed-tools`, and `metadata`.
4. AI_Rules governance fields MUST live under `metadata`, not as extra top-level fields.
5. Frontmatter MUST include `metadata.origin` (`framework` for Shared, `project` for project-derived) and `metadata.style` from Step 1.5.
6. `description` MUST include English + Chinese keywords for IDE trigger matching and explicit `Use when:` / `DO NOT use when:` boundaries.
7. Read `.agents/shared/policies/language-governance.md` before choosing instruction, interface, bridge, trigger, handoff, or generated documentation language; do not copy platform core language paragraphs as the skill source.

### Step 3: Create Directory Structure

Shared framework skill:

```
Shared/skills/{skill-name}/
├── SKILL.md           ← Core instruction file (required)
└── references/        ← Optional L3 resources
    └── ...
```

Project-derived skill:

```
.agents/project_skills/{skill-name}/
├── SKILL.md           ← Core instruction file (required)
└── references/        ← Optional L3 resources
    └── ...
```

### Step 4: Register in Skill Index

1. Shared framework skill: only inside the AI_Rules framework source repository, append one row to `Shared/skills/_index.md`, then sync into platform skills directories.
2. Project-derived skill: append one row to `.agents/project_skills/_index.md`.
3. User Codex skill: do not update AI_Rules project indexes unless Director explicitly requests project registration.
4. Do NOT hand-edit generated platform copies as the source of truth.

### Step 5: Project Skill Discovery Link (專案技能閉環掛載)

Apply this step only to project-derived skills.

1. After the skill directory is created under `.agents/project_skills/{skill-name}/`,
   execute the following to create a flattened symlink under `skills/`:
   ```powershell
   $agentsRoot = Join-Path $workspace '.agents'
   $linkPath   = Join-Path $agentsRoot "skills\project-${skillName}"
   $targetPath = Join-Path $agentsRoot "project_skills\${skillName}"
   if (-not (Test-Path $linkPath)) {
       New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
   }
   ```
2. Verify: `Test-Path` on `$linkPath\SKILL.md` must return `True`.
3. This step is MANDATORY for project-derived skills. A project skill without a symlink is considered **invisible** to the IDE and MUST NOT be marked as complete.

## 4. Format Compliance Rules

### Frontmatter Standard

```yaml
---
name: skill-name
description: >
  [{Domain|Quality|Workflow}] {English description}.
  Use when: {中文觸發條件描述}。
  DO NOT use when: {排他性與負向觸發條件描述}。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework|project
  style: imperative|guided|hybrid
  memory_awareness: none|read|full
  tool_scope: ["{scope}"]
---
```

Do not place AI_Rules-only fields such as required skills, memory awareness, user visibility, lifecycle phase, or human gates at the YAML top level. Put them under `metadata`.

### Body Content Standard

SKILL.md body MUST follow this section order:

1. `# {Skill Name} — {Subtitle}`
2. `## Trigger Conditions` — Decision tree or condition list
3. `## Procedure` — Numbered steps with L3 references inline
4. `## Gotchas` — warnings (if applicable)
5. `## Constraints` — Boundaries and limitations

### §4.5 Writing Style Rules (書寫風格規範)

Read references/skill-style-guide.md for the complete guide. Summary:

```
Every sentence in SKILL.md:
├── Directly affects AI's next action? → Keep
│   ├── Numbered steps / decision trees / rule lists
│   ├── Code examples / lookup tables / gotchas / interpretation
│   └── L3 trigger: "Read references/{file}.md"
└── Does NOT affect action? → Delete or rewrite
    ├── FORBIDDEN: "This skill teaches/enables/provides/extends..."
    ├── FORBIDDEN: "this is because...", "the purpose is..."
    ├── FORBIDDEN: rationale inside decision trees ("→ because...")
    └── Rewrite: narrative openings → decision trees
```

### §4.55 Style Enforcement Rules (風格落地指引)

Read references/skill-style-guide.md §6 for the full density matrix. Summary:

| Style           | Requirements                                                       |
| --------------- | ------------------------------------------------------------------ |
| 🔴 `imperative` | ≥1 code fence gate + HALT mechanism + `[SUDO]` override path       |
| 🟡 `hybrid`     | Code fence gate ONLY at decision nodes, guided procedure elsewhere |
| 🟢 `guided`     | Recipes + gotchas + interpretation. Code fence gates FORBIDDEN     |

### §4.6 Token Budget (Token 預算約束)

| Constraint          | Limit                                         |
| ------------------- | --------------------------------------------- |
| SKILL.md line count | < 500 lines                                   |
| L2 token estimate   | < 5,000 tokens (char count ÷ 3)               |
| Overflow handling   | Move details to `references/` as L3 resources |

### §4.8 Trinity DNA Inheritance (三位一體基因遺傳)

```
[INHERITANCE GATE] For EVERY generated project skill:
├── metadata.style = imperative or hybrid?
│   ├── YES → SKILL.md contains at least one [SILENT GATE] block?
│   │   ├── YES → Proceed.
│   │   └── NO  → Auto-inject Override & Sandbox Detection template (from code-quality § 0).
│   └── NO (guided) → Skip gate injection. Proceed.
├── metadata.style = imperative or hybrid?
│   ├── YES → SKILL.md mentions [SUDO] override path?
│   │   ├── YES → Proceed.
│   │   └── NO  → Auto-inject [SUDO] bypass clause.
│   └── NO (guided) → Skip. Proceed.
└── Gate cleared.
```

### §4.7 agentskills.io Compatibility

| Field         | Rule                                             |
| ------------- | ------------------------------------------------ |
| `name`        | ASCII kebab-case, ≤ 64 characters                |
| `description` | < 1024 characters, no angle brackets             |
| Top-level YAML | only `name`, `description`, `license`, `allowed-tools`, `metadata` |
| Directory     | `{skill-name}/SKILL.md` + optional `references/` |

Run Codex's built-in validator before marking a generated skill as compatible:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "{skill-directory-path}"
```

## 5. Director Review Gate（總監審核閘門）

1. Call `notify_user` with SKILL.md path in `PathsToReview`
2. Prompt: `[技能鍛造] 新技能已建立：{技能功能名稱}。請總監審閱。`
3. Skill is NOT active until Director approves

## 6. Quality Scan Gate（品質掃描閘門）

```
After generating SKILL.md:
1. Run Codex quick_validate.py against {skill-directory-path}
2. For Shared or project-derived AI_Rules skills, run: .agents/scripts/Measure-SkillQuality.ps1 -Target {skill-directory-path}
3. All required validators pass → Submit for Director review
4. Any 🔴 or validation failure → Fix → Re-scan
5. Read references/skill-quality-checklist.md for detailed criteria
```
