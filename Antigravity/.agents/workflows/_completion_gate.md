---
description: Shared silent completion gate for all Writer/Worker workflows.
---

<!-- Shared Completion Gate for all Writer/Worker workflows -->
Execute ALL checks below SILENTLY. Output NOTHING when checks pass.
Output ONLY when a check FAILS — use the halt message format.

```
[COMPLETION GATE — SILENT MODE]
├── [SUDO] detected in session? → Skip ALL checks. Force complete.
├── Check 1: Memory Diff — modified files reflected in memory cards?
│   └── FAIL → 「🔴 [GATE FAIL] 記憶卡未同步。」
├── Check 2: Commit Verification — memory_commit called after last write?
│   └── FAIL → 「🔴 [GATE FAIL] 記憶卡寫入但未歸卡。」
├── Check 3: New File Attribution — new files tracked in memory cards?
│   └── FAIL → 「🔴 [GATE FAIL] 新檔案未歸屬記憶卡。」
├── Check 4: Interface Layer — completion uses business language?
│   └── FAIL → Self-correct internally. No output needed.
├── Check 5: Granularity — trackedFiles ≤ 8 per card?
│   └── FAIL → 「🟡 [GATE WARN] 記憶卡過載，建議拆分。」
├── Check 6: Skill Distillation — reusable pattern detected?
│   └── If yes → RECOMMEND /12_skill_forge (non-blocking).
├── Check 7: Documentation Sync — framework docs may need update?
│   ├── Read _system memory → ## Documentation Files list.
│   ├── No list defined? → Skip silently.
│   └── List exists + ≥ 5 framework files modified this session?
│       → 「🟡 [DOC REMIND] 本次修改 {N} 支框架檔案。建議檢查系統文件是否需同步。」
│       Non-blocking. Continue.
└── ALL PASS → Proceed silently. Zero output.
```