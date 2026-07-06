# Skill Quality Checklist

The `Measure-SkillQuality.ps1` quality scanner evaluates skill compliance against this checklist.

## Checklist

### 1. Line Count Limit

- **Rule**: `SKILL.md` stays under 500 lines.
- **Result**: Green when compliant, Red when oversized.
- **Fix**: Move overflow material into `references/` as L3 resources.

### 2. Token Budget

- **Rule**: Character count divided by 3 stays under 5,000.
- **Result**: Green when compliant, Red when oversized.
- **Basis**: agentskills.io L2 limit below 5,000 tokens.

### 3. Forbidden Tutorial Wording

- **Rule**: The body must not contain these patterns:
  - `This skill teaches`
  - `This skill enables`
  - `This skill provides`
  - `This skill extends`
  - `this is because`
  - `the purpose is`
  - `the reason is`
- **Result**: Green when clean, Red when forbidden wording appears.
- **Fix**: Use the replacements in `skill-style-guide.md` section 2.

### 4. Frontmatter Completeness

- **Required fields**:
  - `name` - kebab-case skill name
  - `description` - functional description with Traditional Chinese trigger keywords first, plus optional English supplemental text
  - `metadata.author` - author
  - `metadata.version` - version
  - `metadata.origin` - `framework` or `project`
- **Result**: Green when complete, Red when a required field is missing.

### 4.5 Traditional Chinese Trigger Requirement

- **Rule**: `description` MUST start with Traditional Chinese task meaning as the first readable content.
- **Required**: Chinese trigger wording first is mandatory, not recommended.
- **Forbidden first readable content**: `[{Domain}]`, `Use when:`, `DO NOT use when:`, `when`, or any English-only label.
- **Scope labels**: `Use when:` and `DO NOT use when:` may stay canonical English, but the text after each label MUST start with Traditional Chinese trigger or exclusion meaning.
- **Result**: Red when description, positive triggers, or negative boundaries are English-only; when Chinese trigger terms are only optional; or when English labels appear before Chinese meaning.
- **Fix**: Add Chinese task-domain words and real user phrasing first; keep canonical English keys or ecosystem terms only as supplemental precision.

### 5. agentskills.io Compatibility

- **name**: ASCII kebab-case, 64 characters or fewer.
- **description**: Under 1024 characters, with no angle brackets.
- **top-level YAML**: Only `name`, `description`, `license`, `allowed-tools`, and `metadata` are allowed.
- **AI_Rules governance fields**: Must be nested under `metadata`; do not add extra top-level YAML fields.
- **Result**: Green when compatible, Red when incompatible.

Confirm Codex compatibility with the built-in validator:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "{skill-directory-path}"
```

### 5.5 Layer Placement

- **Shared framework skill**: In the AI_Rules framework source repository only, place it under `Shared/skills/{skill-name}/` and update `Shared/skills/_index.md`.
- **Project-derived skill**: Place it under `.agents/project_skills/{project-code}-{skill-name}/`, update `.agents/project_skills/_index.md`, and create a discovery link.
- **User Codex skill**: Place it in the user's Codex skills directory; do not update the AI_Rules project index unless the Director explicitly asks.
- **Result**: Green when the layer is correct, Red when placed in the wrong layer.

### 6. L3 Embedding State

- **Condition**: Check only when the skill has a `references/` directory.
- **Rule**: Steps include `Read references/` or cite `references/*.md`.
- **Result**: Green when embedded, Yellow when missing, not-applicable when no references exist.

## Overall Result Logic

```
Any Red -> overall Red
No Red and at least one Yellow -> overall Yellow
All Green -> overall Green
```

### 7. Style Cross-Check

- **Prerequisite**: `metadata.style` is declared.
- **Rule**:
  ```
  metadata.style declared?
  ├── Missing -> Red: style field is missing
  ├── imperative -> body contains at least one code-fence gate?
  │   ├── YES -> Green
  │   └── NO  -> Red: imperative style without a gate
  ├── guided -> body contains a code-fence gate?
  │   ├── NO  -> Green
  │   └── YES -> Red: guided style contains a gate
  └── hybrid -> body contains a code-fence gate?
      ├── YES -> Green
      └── NO  -> Yellow: hybrid style has no gate
  ```
- **Result**: Follow the decision tree above.
- **Fix**: Adjust the `metadata.style` declaration or add/remove gates until the body matches it.

### 8. Negative Trigger Completeness

- **Rule**: `description` includes a `DO NOT use when:` section.
- **Result**: Green when present, Yellow when missing.
- **Fix**: Add exclusions that match the skill boundary, using peer skills as the pattern.
